"""Shrink the corpus to a target size per engine, keeping coverage spread.

gem5 labels one benchmark per sim, so a smaller, well-spread corpus is usually
better than a big redundant one. This prunes each engine down to `--per-engine`
samples using *stratified* selection: it buckets samples by
(op_name, dtype, log2-size) and round-robins across buckets, so the kept subset
still spans every op family, dtype, and size band instead of clumping.

Real-world-pull samples are kept by default (scarce, real deployment shapes);
pass --drop-realworld to subject them to the same budget.

    python -m dataset.scripts.subsample --per-engine 400            # preview (dry-run)
    python -m dataset.scripts.subsample --per-engine 400 --apply    # actually delete
"""

from __future__ import annotations

import argparse
import json
import math
import random
from collections import defaultdict
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent.parent


def _size(meta: dict) -> int:
    if {"M", "N", "K"} <= meta.keys():
        return meta["M"] * meta["N"] * meta["K"]
    if {"H", "W"} <= meta.keys():
        return meta["H"] * meta["W"] * meta.get("Cout", 1)
    if "n" in meta:
        return int(meta["n"])
    return 1


def _bucket_key(o: dict) -> tuple:
    meta = o.get("meta", {})
    dt = meta.get("dtype", "?")
    return (o["op_name"], dt, int(math.log2(max(1, _size(meta)))))


def _select(samples: list[dict], target: int, rng: random.Random) -> set[str]:
    """Round-robin across (op,dtype,size) buckets up to `target` uids."""
    buckets: dict[tuple, list[dict]] = defaultdict(list)
    for o in samples:
        buckets[_bucket_key(o)].append(o)
    for b in buckets.values():
        rng.shuffle(b)
    keys = sorted(buckets, key=lambda k: (str(k)))
    keep: set[str] = set()
    progress = True
    while len(keep) < target and progress:
        progress = False
        for k in keys:
            if buckets[k]:
                keep.add(buckets[k].pop()["uid"])
                progress = True
                if len(keep) >= target:
                    break
    return keep


def subsample(corpus_root: Path, per_engine: int, *, keep_realworld: bool = True,
              seed: int = 0, apply: bool = False) -> dict[str, tuple[int, int]]:
    rng = random.Random(seed)
    report: dict[str, tuple[int, int]] = {}
    for engine in ("me", "ve", "scalar"):
        d = corpus_root / engine
        if not d.exists():
            continue
        objs = [json.loads(j.read_text()) for j in sorted(d.glob("*.json"))]
        total = len(objs)

        forced = {o["uid"] for o in objs
                  if keep_realworld and o.get("meta", {}).get("source") != "synthetic"}
        pool = [o for o in objs if o["uid"] not in forced]
        budget = max(0, per_engine - len(forced))
        keep = forced | _select(pool, budget, rng)

        for o in objs:
            if o["uid"] in keep:
                continue
            if apply:
                (d / f"{o['uid']}.mlir").unlink(missing_ok=True)
                (d / f"{o['uid']}.json").unlink(missing_ok=True)
        report[engine] = (total, len(keep))
    return report


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--corpus", type=Path, default=REPO / "dataset" / "corpus")
    ap.add_argument("--per-engine", type=int, required=True)
    ap.add_argument("--drop-realworld", action="store_true",
                    help="include real-world samples in the budget (default keeps them)")
    ap.add_argument("--seed", type=int, default=0)
    ap.add_argument("--apply", action="store_true",
                    help="actually delete (default is a dry-run preview)")
    args = ap.parse_args(argv)

    rep = subsample(args.corpus, args.per_engine,
                    keep_realworld=not args.drop_realworld,
                    seed=args.seed, apply=args.apply)
    mode = "DELETED" if args.apply else "would keep (dry-run)"
    for e, (total, kept) in rep.items():
        print(f"  {e}: {total} -> {kept}   ({total - kept} {mode})")
    if not args.apply:
        print("\n  dry-run only; re-run with --apply to delete.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
