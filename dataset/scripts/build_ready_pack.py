"""Build a shippable per-engine `<engine>_ready` pack (fujitsu-624-test style).

One dir per benchmark (model.mlir + pre-generated benchmark_runner.c + thin
Makefile), a shared common.mk + build_all.sh + README, NO manifest/tools.
Real-world ops whose runner can't be generated are skipped (SKIPPED.txt).

Quarantine:
  * ME  -- derived from the spec, per (input, accumulator) *mode*, via
           `policy.me_bucket`.  Runnable modes (FP8->FP32, FP16->FP32,
           FP16->FP16) go in the top level; the rest are lifted into
           `unsupported_i8/`, `unsupported_bf16/`, `unsupported_bf16_f16acc/`
           (does not compile) and `unsupported_f32/` (not an ME mode at all).
  * VE / Scalar -- no systolic array, so no dtype gap; flat by default.
                   `--quarantine i8,bf16` can still lift dtypes if needed.

    python -m dataset.scripts.build_ready_pack --engine me
    python -m dataset.scripts.build_ready_pack --engine ve
    python -m dataset.scripts.build_ready_pack --engine scalar
"""
from __future__ import annotations

import argparse
import glob
import json
import re
import shutil
import sys
from pathlib import Path

from dataset.scripts.policy import me_bucket

REPO = Path(__file__).resolve().parent.parent.parent
HARNESS = Path(__file__).resolve().parent / "harness"   # common.mk + generate_runner.py
OFA = str(REPO.parent / "OFA-compiler-master")
sys.path.insert(0, str(HARNESS))
import generate_runner as gr  # noqa: E402

CORPUS_DIRS = {"me": ["me"], "ve": ["ve"], "scalar": ["scalar", "extras/scalar"]}
SUPPORT = {"me": "--support-me", "ve": "--support-ve", "scalar": ""}

_TENSOR_ELEM = re.compile(r"tensor<[\dx]*x([A-Za-z0-9]+)>")

BUCKET_NOTE = {
    "unsupported_i8": "INT8->INT32: compiles, but ME INT8 support is still missing "
                      "(and INT8 is absent from the planned-datatype table)",
    "unsupported_bf16": "BF16->FP32: compiles, but gem5 reports Build OK / Run FAIL",
    "unsupported_bf16_f16acc": "BF16->FP16: does NOT compile — linalg.matmul only inserts "
                               "widening accumulator casts, so bf16 into an f16 accumulator "
                               "fails with \"'arith.addf' op requires the same type for all "
                               "operands and results\". Matches the planned table, where every "
                               "FP16-accumulator column in the BF16 rows is \"-\". Shipped for "
                               "the record; expected to fail at build.",
    "unsupported_f32": "FP32 is not an ME input mode at all (real-world batch_matmul; "
                       "dims are also not array-aligned)",
}


def _bucket(engine: str, meta: dict, mlir: Path, quar: set[str]) -> tuple[str, str]:
    """(quarantine subfolder, dtype label) for one benchmark."""
    dt = meta.get("dtype")
    if engine == "me":
        if dt is None:                      # real-world op: read it off the IR
            m = _TENSOR_ELEM.search(mlir.read_text())
            dt = m.group(1) if m else "unknown"
        return me_bucket(dt, meta.get("acc", dt)), dt
    dt = dt or "real-world"
    return (f"unsupported_{dt}" if dt in quar else ""), dt


MAKEFILE = ("# {uid}  ({op}, {dtype})\n"
            "NAME := {uid}\nSUPPORT_FLAGS := {flags}\n"
            "BENCH_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))\n"
            "OFA_ROOT ?= {ofa}\ninclude $(BENCH_DIR)/{rel}/common.mk\n")

BUILD_ALL = """\
#!/usr/bin/env bash
# Build the {engine} benchmark ELFs for gem5. Builds the RUNNABLE set (top-level
# dirs) by default; unsupported_* subfolders build but currently fail on gem5.
#   ./build_all.sh OFA_ROOT=/path/to/OFA-compiler-master [RISCV_CC=... OBJCOPY=...]
#   INCLUDE_UNSUPPORTED=1 ./build_all.sh OFA_ROOT=...     # also build {quar}
#   JOBS=8 ./build_all.sh OFA_ROOT=...
set -u
here="$(cd "$(dirname "$0")" && pwd)"
export MAKEVARS="$*"
jobs="${{JOBS:-$(nproc 2>/dev/null || echo 4)}}"
dirs=$(find "$here" -mindepth 1 -maxdepth 1 -type d ! -name 'unsupported_*')
if [ "${{INCLUDE_UNSUPPORTED:-0}}" = 1 ]; then
  dirs="$dirs
$(find "$here"/unsupported_* -mindepth 1 -maxdepth 1 -type d 2>/dev/null)"
fi
printf '%s\\n' $dirs | xargs -P "$jobs" -I{{}} bash -c '
    d="$1"
    if make -C "$d" elf $MAKEVARS >"$d/build.log" 2>&1; then echo "PASS $(basename "$d")"
    else echo "FAIL $(basename "$d")  ($(tail -n1 "$d/build.log" 2>/dev/null))"; fi' _ {{}} \\
  | tee "$here/build_results.log"
echo "=== $(grep -c '^PASS' "$here/build_results.log") / $(wc -l < "$here/build_results.log") built ==="
"""


def main(argv=None) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--engine", required=True, choices=["me", "ve", "scalar"])
    ap.add_argument("--out", type=Path, default=None)
    ap.add_argument("--quarantine", default="",
                    help="VE/Scalar only: dtypes to lift into unsupported_*/ "
                         "(ME quarantine is spec-driven via policy.me_bucket)")
    args = ap.parse_args(argv)
    quar = set(x for x in args.quarantine.split(",") if x)
    out = args.out or Path(f"/home/weizchen/code/{args.engine}_ready")
    shutil.rmtree(out, ignore_errors=True); out.mkdir(parents=True)
    shutil.copyfile(HARNESS / "common.mk", out / "common.mk")

    counts, skipped = {}, []
    for d in CORPUS_DIRS[args.engine]:
        for j in sorted(glob.glob(str(REPO / "dataset" / "corpus" / d / "*.json"))):
            o = json.loads(Path(j).read_text()); uid = o["uid"]
            mlir = Path(j[:-5] + ".mlir")
            sub, dt = _bucket(args.engine, o["meta"], mlir, quar)
            try:
                runner = gr.render_source(gr.parse_signature(mlir), uid)
            except Exception as e:
                skipped.append(f"{uid}: {str(e).split(':')[0]}"); continue
            rel = ".." if sub == "" else "../.."
            bdir = (out / sub / uid) if sub else (out / uid)
            bdir.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(mlir, bdir / "model.mlir")
            (bdir / "benchmark_runner.c").write_text(runner)
            (bdir / "Makefile").write_text(MAKEFILE.format(
                uid=uid, op=o["op_name"], dtype=dt, flags=SUPPORT[args.engine], ofa=OFA, rel=rel))
            counts[sub or "main"] = counts.get(sub or "main", 0) + 1
    ba = out / "build_all.sh"
    ba.write_text(BUILD_ALL.format(engine=args.engine, quar=" / ".join(sorted(quar))))
    ba.chmod(0o755)
    if skipped:
        (out / "SKIPPED.txt").write_text("\n".join(skipped) + "\n")
    buckets = sorted(k for k in counts if k != "main")
    lines = [f"# {args.engine}_ready", "",
             f"All {args.engine.upper()} single-op benchmarks, harnessed for gem5 "
             f"(fujitsu-624-test layout).", ""]
    if args.engine == "me":
        lines += [
            "Matrix Engine matmuls, one per (input, accumulator) **mode** declared in "
            "`targets/Processors/MatrixEngine.json`. Every M/K/N is a **multiple of the "
            "mode's systolic array edge** (128 for INT8/FP8, 64 for FP16/BF16), as the ME "
            "requires.", "",
            "Runnable (top-level dirs): `FP8->FP32` (128x128), `FP16->FP32` and "
            "`FP16->FP16` (64x64).", ""]
    for b in buckets:
        lines.append(f"* `{b}/` ({counts[b]}) — {BUCKET_NOTE.get(b, 'currently unsupported')}")
    if buckets:
        lines.append("")
    lines += [f"Layout: {counts}", "",
              "Build:  `./build_all.sh OFA_ROOT=/path/to/OFA-compiler-master`"]
    if buckets:
        lines.append("        `INCLUDE_UNSUPPORTED=1 ./build_all.sh OFA_ROOT=...`  "
                     f"(also builds {buckets})")
    lines += ["",
              "Each `<uid>/` = model.mlir + pre-generated benchmark_runner.c + Makefile. "
              "ELFs land at `<uid>/out/<uid>.elf`. Report cycles back keyed by `<uid>` "
              "(uid, build, run, sim_ticks, sim_seconds)."]
    (out / "README.md").write_text("\n".join(lines) + "\n")
    print(f"{args.engine}_ready -> {out}   layout={counts}   skipped={len(skipped)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
