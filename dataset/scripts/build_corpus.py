"""Build the complete corpus: synthetic sweeps + real-world pull, de-duped.

Two sources land in the same `dataset/corpus/<engine>/` format:

  1. Synthetic sweeps  — dense shape/dtype grids over the high-volume op
     families (ME matmul, VE/scalar elementwise + reduction).
  2. Real-world pull   — every linalg op from `OFA/Benchmarks/*/model.mlir`,
     extracted as a single-op module by `nail-extract-linalg-benchmarks`
     (run once per model with engine=all), normalized first via the
     benchmark Makefile's `normalize_mlir.py`.

Both are de-duped per engine by `region_hash`, so the same op shape recurring
across hundreds of transformer layers collapses to one sample.

    python -m dataset.scripts.build_corpus                 # everything, default sizes
    python -m dataset.scripts.build_corpus --no-realworld  # synthetic only
    python -m dataset.scripts.build_corpus --me 2000 --ve 1000 --scalar 1000
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(REPO))

from dataset.scripts.builders.contraction import build_contraction_corpus  # noqa: E402
from dataset.scripts.builders.conv import build_conv_corpus          # noqa: E402
from dataset.scripts.builders.me import build_me_corpus              # noqa: E402
from dataset.scripts.builders.scalar import build_scalar_corpus      # noqa: E402
from dataset.scripts.builders.structured import build_structured_corpus  # noqa: E402
from dataset.scripts.builders.transpose import build_transpose_corpus  # noqa: E402
from dataset.scripts.builders.ve import build_ve_corpus              # noqa: E402
from dataset.scripts.ingest import sample_from_file                  # noqa: E402
from dataset.scripts.schema import load_corpus                       # noqa: E402
from dataset.scripts.verify import verify_compile, verify_parse      # noqa: E402

_OFA_ROOT = Path(os.environ.get("OFA_ROOT", REPO.parent / "OFA-compiler-master"))
_OFA_OPT = Path(os.environ.get("OFA_OPT", _OFA_ROOT / "build" / "bin" / "ofa-opt"))
_NORMALIZER = _OFA_ROOT / "Benchmarks" / "common" / "normalize_mlir.py"
_BENCH_DIR = _OFA_ROOT / "Benchmarks"


def _sanitize(s: str) -> str:
    return re.sub(r"[^A-Za-z0-9_-]", "_", s)


def _seen_hashes(corpus_root: Path) -> dict[str, set[str]]:
    """Existing region hashes per engine, so the pull is idempotent."""
    seen: dict[str, set[str]] = {"me": set(), "ve": set(), "scalar": set()}
    for e in seen:
        for d in (corpus_root / e, corpus_root / "extras" / e):
            if d.exists():
                seen[e].update(s.region_hash for s in load_corpus(d))
    return seen


def build_synthetic(corpus_root: Path, n_me: int, n_ve: int, n_scalar: int,
                    seed: int, cross_engine: bool = False, n_conv: int = 0,
                    n_contraction: int = 0, n_transpose: int = 0,
                    n_structured: int = 0) -> dict[str, int]:
    counts: dict[str, int] = {}
    if n_me:
        counts["me"] = build_me_corpus(corpus_root / "me", n_me, seed,
                                       cross_engine=cross_engine)
    if n_ve:
        counts["ve"] = build_ve_corpus(corpus_root / "ve", n_ve, seed)
    if n_scalar:
        counts["scalar"] = build_scalar_corpus(corpus_root / "scalar", n_scalar, seed)
    # conv2d and the batch_matmul/matvec/vecmat contraction family FAIL to lower
    # on VE under the upgraded compiler -> Scalar only.
    if n_conv:
        build_conv_corpus(corpus_root / "scalar", n_conv, seed, engine="scalar")
    if n_contraction:
        build_contraction_corpus(corpus_root / "scalar", n_contraction, seed,
                                 engine="scalar")
    # transpose + the structured Tier-2 ops lower on both VE and Scalar; VE drops
    # the reduce form (broken VE reduction).
    if n_transpose:
        build_transpose_corpus(corpus_root / "ve", n_transpose, seed, engine="ve")
        build_transpose_corpus(corpus_root / "scalar", n_transpose, seed, engine="scalar")
    if n_structured:
        build_structured_corpus(corpus_root / "ve", n_structured, seed,
                                engine="ve", emit_reduce=False)
        build_structured_corpus(corpus_root / "scalar", n_structured, seed,
                                engine="scalar", emit_reduce=True)
    return counts


def split_extras(corpus_root: Path) -> dict[str, int]:
    """Move out-of-spec samples to `corpus/extras/<engine>/`, tagged.

    An op is out-of-spec when its `categoryOf` bucket isn't in the engine's
    `policies.supported_ops` (e.g. matmul/batch_matmul/conv on the scalar core).
    Such ops still lower — they're real fallback lowerings — so they're retained
    here rather than dropped, with `meta.spec_supported=false` + a reason, so it
    is obvious what is kept beyond spec.
    """
    from dataset import policy
    from dataset.scripts.schema import LinalgOpSample

    moved: dict[str, int] = {}
    for engine in ("me", "ve", "scalar"):
        eng_dir = corpus_root / engine
        if not eng_dir.exists():
            continue
        for j in sorted(eng_dir.glob("*.json")):
            s = LinalgOpSample.from_json(json.loads(j.read_text()))
            ok = policy.spec_supported(engine, s.op_name, s.meta)
            s.meta["spec_supported"] = ok
            if ok:
                j.write_text(json.dumps(s.to_json(), indent=2))  # tag in place
                continue
            s.meta["spec_reason"] = policy.spec_reason(engine, s.op_name, s.meta)
            dst = corpus_root / "extras" / engine
            dst.mkdir(parents=True, exist_ok=True)
            mlir = j.with_suffix(".mlir")
            if mlir.exists():
                shutil.move(str(mlir), str(dst / mlir.name))
            s.write(dst / j.name)
            j.unlink()
            moved[engine] = moved.get(engine, 0) + 1
    return moved


def realworld_pull(corpus_root: Path, seen: dict[str, set[str]],
                   gate: str = "compile"
                   ) -> tuple[dict[str, int], int, int, int]:
    """Extract + ingest every benchmark model. Returns (added per engine,
    n_models_processed, n_featurized, n_dropped).

    `gate` rejects extracted modules that aren't actually usable, so broken
    ops never enter the corpus:
      "compile" — must lower to LLVM IR via ofa-compiler (strongest; default)
      "parse"   — must parse/verify via ofa-opt (fast)
      "none"    — accept anything (debug only)

    The known offender: ops whose region body captures an outside SSA value
    (a constant bias / f64 literal feeding truncf). The extractor doesn't
    carry the capture, so the clone dangles (`<<UNKNOWN SSA VALUE>>`) and
    fails to parse. The gate drops those rather than poisoning the corpus.
    """
    if not _OFA_OPT.exists():
        print(f"  ofa-opt not found at {_OFA_OPT}; skipping real-world pull")
        return {}, 0, 0, 0
    if not _NORMALIZER.exists():
        print(f"  normalizer not found at {_NORMALIZER}; skipping")
        return {}, 0, 0, 0

    models = sorted(_BENCH_DIR.glob("**/model.mlir"))
    print(f"  {len(models)} benchmark model(s) found under {_BENCH_DIR}")
    added = {"me": 0, "ve": 0, "scalar": 0}
    n_models = 0
    n_feat = 0
    n_dropped = 0

    with tempfile.TemporaryDirectory() as td:
        tmp = Path(td)
        for model in models:
            bench = _sanitize(model.parent.name)
            norm = tmp / f"{bench}.norm.mlir"
            r = subprocess.run([sys.executable, str(_NORMALIZER),
                                str(model), str(norm)],
                               capture_output=True, text=True)
            if r.returncode != 0 or not norm.exists():
                print(f"    [skip] normalize failed: {bench}")
                continue

            ex = tmp / f"ex_{bench}"
            r = subprocess.run(
                [str(_OFA_OPT),
                 f"--nail-extract-linalg-benchmarks=engine=all "
                 f"output-dir={ex} source-id={bench}",
                 str(norm), "-o", os.devnull],
                capture_output=True, text=True)
            if r.returncode != 0:
                print(f"    [skip] extract failed: {bench}")
                continue
            n_models += 1

            for f in sorted(ex.glob("*.mlir")):
                s = sample_from_file(f, bench)
                if s is None:
                    continue
                if s.region_hash in seen[s.engine]:
                    continue            # dedup: same op already in corpus
                seen[s.engine].add(s.region_hash)

                if gate == "compile" and not verify_compile(f).ok:
                    n_dropped += 1
                    continue
                if gate == "parse" and not verify_parse(f).ok:
                    n_dropped += 1
                    continue

                dst = corpus_root / s.engine
                dst.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(f, dst / f"{s.uid}.mlir")
                s.write(dst / f"{s.uid}.json")
                added[s.engine] += 1
                if s.meta.get("featurized"):
                    n_feat += 1
    return added, n_models, n_feat, n_dropped


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--corpus", type=Path, default=REPO / "dataset" / "corpus")
    ap.add_argument("--me", type=int, default=1500, help="synthetic ME samples")
    ap.add_argument("--ve", type=int, default=800, help="synthetic VE samples")
    ap.add_argument("--scalar", type=int, default=600, help="synthetic scalar samples")
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--no-synth", action="store_true")
    ap.add_argument("--no-realworld", action="store_true")
    ap.add_argument("--cross-engine", action="store_true",
                    help="also emit bf16/i8 matmuls for VE and Scalar")
    ap.add_argument("--conv", type=int, default=0,
                    help="synthetic conv2d samples per VE/Scalar engine")
    ap.add_argument("--contraction", type=int, default=0,
                    help="batch_matmul/matvec/vecmat samples per VE/Scalar engine")
    ap.add_argument("--transpose", type=int, default=0,
                    help="transpose samples per VE/Scalar engine")
    ap.add_argument("--structured", type=int, default=0,
                    help="reduce/broadcast/copy/elementwise/select per VE/Scalar engine")
    ap.add_argument("--gate", choices=["compile", "parse", "none"],
                    default="compile",
                    help="validity gate for real-world ops (default: compile)")
    ap.add_argument("--fresh", action="store_true",
                    help="delete existing corpus dirs first")
    args = ap.parse_args(argv)

    root = args.corpus
    if args.fresh:
        for e in ("me", "ve", "scalar"):
            shutil.rmtree(root / e, ignore_errors=True)
        shutil.rmtree(root / "extras", ignore_errors=True)

    if not args.no_synth:
        print("== synthetic sweeps ==")
        sc = build_synthetic(root, args.me, args.ve, args.scalar, args.seed,
                             cross_engine=args.cross_engine, n_conv=args.conv,
                             n_contraction=args.contraction, n_transpose=args.transpose,
                             n_structured=args.structured)
        for e, n in sc.items():
            print(f"  {e}: {n} synthetic samples")
        if args.cross_engine:
            print("  (+ matmuls mirrored onto VE & Scalar where each engine's "
                  "precision matrix admits the dtype)")
        extras = [name for name, on in (("conv2d", args.conv),
                  ("batch_matmul/matvec/vecmat", args.contraction),
                  ("transpose", args.transpose),
                  ("reduce/broadcast/copy/elementwise/select", args.structured)) if on]
        if extras:
            print(f"  (+ {', '.join(extras)} on VE & Scalar)")

    if not args.no_realworld:
        print("== real-world pull ==")
        seen = _seen_hashes(root)
        added, n_models, n_feat, n_dropped = realworld_pull(root, seen, args.gate)
        if added:
            for e in ("me", "ve", "scalar"):
                print(f"  {e}: +{added.get(e, 0)} real-world samples (deduped)")
            print(f"  processed {n_models} models; {n_feat} real-world "
                  f"samples got v1 features (rest are text-only / v2)")
            print(f"  dropped {n_dropped} unusable ops (gate={args.gate}: "
                  f"captured-SSA / non-lowering)")

    print("== spec split (retained-but-out-of-spec -> extras/) ==")
    moved = split_extras(root)
    if moved:
        for e, n in sorted(moved.items()):
            print(f"  moved {n} out-of-spec {e} op(s) -> extras/{e}/ "
                  f"(tagged spec_supported=false)")
    else:
        print("  (nothing out-of-spec)")

    print("== corpus totals ==")
    grand = 0
    for e in ("me", "ve", "scalar"):
        n = len(list((root / e).glob("*.json"))) if (root / e).exists() else 0
        grand += n
        print(f"  {e}: {n}")
    for e in ("me", "ve", "scalar"):
        ed = root / "extras" / e
        n = len(list(ed.glob("*.json"))) if ed.exists() else 0
        if n:
            grand += n
            print(f"  extras/{e}: {n}")
    print(f"  TOTAL: {grand} modules under {root}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
