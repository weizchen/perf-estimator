"""Dataset record schema for the perf-estimator pipeline.

One `LinalgOpSample` = one single-op linalg benchmark (`.mlir` file wrapping
exactly one `linalg.<op>` inside a `nail.unit { proc: <engine> }`). Each sample
gets one cycle label per engine — Fujitsu's gem5 produces those externally and
they're attached here via `label_cycles`. v1 trains three independent
per-engine models on disjoint corpus partitions; no cross-engine routing.
"""

from __future__ import annotations

import json
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any, Literal, Optional

Engine = Literal["me", "ve", "scalar"]

# proc id <-> engine name (matches NAILTypes.td: 0=RISC, 1=VE, 2=ME).
PROC_OF_ENGINE: dict[Engine, int] = {"scalar": 0, "ve": 1, "me": 2}
ENGINE_OF_PROC: dict[int, Engine] = {v: k for k, v in PROC_OF_ENGINE.items()}


@dataclass
class LinalgOpSample:
    """One single-op linalg benchmark with its features and (optional) label."""

    uid: str
    engine: Engine
    op_name: str                 # e.g. "linalg.matmul", "linalg.generic"
    region_mlir: str             # textual body of the wrapped op
    region_hash: str             # SSA-invariant canonical hash (dedup key)
    features: list[float]        # engine-specific feature vector
    label_cycles: Optional[float] = None
    meta: dict[str, Any] = field(default_factory=dict)

    def to_json(self) -> dict[str, Any]:
        return {
            "uid": self.uid,
            "engine": self.engine,
            "op_name": self.op_name,
            "region_mlir": self.region_mlir,
            "region_hash": self.region_hash,
            "features": list(self.features),
            "label_cycles": self.label_cycles,
            "meta": self.meta,
        }

    @staticmethod
    def from_json(o: dict[str, Any]) -> "LinalgOpSample":
        return LinalgOpSample(
            uid=o["uid"],
            engine=o["engine"],
            op_name=o["op_name"],
            region_mlir=o["region_mlir"],
            region_hash=o["region_hash"],
            features=list(o.get("features", [])),
            label_cycles=o.get("label_cycles"),
            meta=dict(o.get("meta", {})),
        )

    def write(self, json_path: Path) -> None:
        json_path.parent.mkdir(parents=True, exist_ok=True)
        json_path.write_text(json.dumps(self.to_json(), indent=2))


def load_corpus(corpus_dir: Path) -> list[LinalgOpSample]:
    """Load every `*.json` sample under a per-engine corpus directory."""
    samples: list[LinalgOpSample] = []
    for j in sorted(corpus_dir.glob("*.json")):
        samples.append(LinalgOpSample.from_json(json.loads(j.read_text())))
    return samples
