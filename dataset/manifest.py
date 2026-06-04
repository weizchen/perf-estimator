"""Emit one corpus_index.jsonl across all engines — the gem5 handoff manifest.

One record per benchmark module, joining the file the simulator runs to its
identity and the slot its cycle label comes back into:

    {"uid", "engine", "op_name", "file", "region_hash", "dtype", "shape",
     "label_cycles": null, "source"}

`file` is relative to the corpus root. `region_hash` is the dedup key.
`label_cycles` is null until gem5 fills it (see `ingest_labels`).

    python -m dataset.manifest                      # write dataset/corpus/corpus_index.jsonl
    python -m dataset.manifest --labels results.jsonl  # merge gem5 cycles back in
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
_DTYPE = re.compile(r"x(f8E5M2|bf16|f16|f32|f64|i8|i16|i32|i64)>")
_TENSOR = re.compile(r"tensor<([0-9x]+)x[A-Za-z0-9]+>")


def _dtype_of(region: str) -> str:
    m = _DTYPE.findall(region)
    return m[0] if m else "?"


def _shape_of(meta: dict, region: str) -> str:
    if {"M", "N", "K"} <= meta.keys():
        return f"{meta['M']}x{meta['K']}x{meta['N']}"
    if {"H", "W", "Cin", "Cout", "Kh"} <= meta.keys():
        return f"{meta['H']}x{meta['W']}x{meta['Cin']}->{meta['Cout']} k{meta['Kh']}"
    if "n" in meta:
        return str(meta["n"])
    m = _TENSOR.search(region)            # real-world fallback: first tensor
    return m.group(1) if m else "?"


def build_manifest(corpus_root: Path) -> list[dict]:
    rows: list[dict] = []
    for engine in ("me", "ve", "scalar"):
        d = corpus_root / engine
        if not d.exists():
            continue
        for j in sorted(d.glob("*.json")):
            o = json.loads(j.read_text())
            meta = o.get("meta", {})
            rows.append({
                "uid": o["uid"],
                "engine": o["engine"],
                "op_name": o["op_name"],
                "file": f"{engine}/{o['uid']}.mlir",
                "region_hash": o["region_hash"],
                "dtype": meta.get("dtype") or _dtype_of(o["region_mlir"]),
                "shape": _shape_of(meta, o["region_mlir"]),
                "source": meta.get("source", "synthetic"),
                "cross_engine": bool(meta.get("cross_engine", False)),
                "expected_lower": bool(meta.get("expected_lower", True)),
                "label_cycles": o.get("label_cycles"),
            })
    return rows


def write_manifest(corpus_root: Path, out: Path | None = None) -> Path:
    rows = build_manifest(corpus_root)
    out = out or corpus_root / "corpus_index.jsonl"
    with out.open("w") as f:
        for r in rows:
            f.write(json.dumps(r) + "\n")
    return out


def ingest_labels(corpus_root: Path, labels_jsonl: Path) -> int:
    """Merge gem5 results ({"uid":..,"label_cycles":..} per line) into the
    per-sample .json sidecars. Returns the number of labels applied."""
    by_uid = {}
    for line in labels_jsonl.read_text().splitlines():
        line = line.strip()
        if line:
            r = json.loads(line)
            by_uid[r["uid"]] = r["label_cycles"]
    applied = 0
    for engine in ("me", "ve", "scalar"):
        for j in (corpus_root / engine).glob("*.json"):
            o = json.loads(j.read_text())
            if o["uid"] in by_uid:
                o["label_cycles"] = by_uid[o["uid"]]
                j.write_text(json.dumps(o, indent=2))
                applied += 1
    return applied


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--corpus", type=Path, default=REPO / "dataset" / "corpus")
    ap.add_argument("--out", type=Path, default=None)
    ap.add_argument("--labels", type=Path, default=None,
                    help="gem5 results jsonl to merge back into sidecars")
    args = ap.parse_args(argv)

    if args.labels:
        n = ingest_labels(args.corpus, args.labels)
        print(f"applied {n} labels from {args.labels}")
    out = write_manifest(args.corpus, args.out)
    rows = build_manifest(args.corpus)
    labeled = sum(1 for r in rows if r["label_cycles"] is not None)
    print(f"wrote {len(rows)} records ({labeled} labeled) to {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
