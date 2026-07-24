"""Turn extractor output into trainable corpus samples.

The `nail-extract-linalg-benchmarks` pass emits bare standalone `.mlir`
modules (one wrapped linalg op each). This module reads such a file, pulls out
the op body, computes the SSA-invariant `region_hash` (the dedup key), runs the
engine's featurizer best-effort, and produces a `LinalgOpSample` — the same
record the synthetic builders emit. So real-world-pull output lands in the same
`dataset/corpus/<engine>/` format as the synthetic sweeps.

Real-world ops are more varied than the synthetic templates (contraction-style
generics, multi-operand bodies, named ops the v1 featurizer doesn't parse). The
featurizer is therefore best-effort: when it can't parse a body, `features` is
left empty. The `.mlir` + `region_hash` + provenance are always populated, so
the sample is still a complete gem5 benchmark and a v2 (text-model) input.
"""

from __future__ import annotations

import re
import textwrap
from pathlib import Path
from typing import Optional

from dataset.scripts.canonicalize import region_hash
from dataset.scripts.features import (
    feature_vector_me, feature_vector_scalar, feature_vector_ve,
    parse_generic, parse_matmul,
)
from dataset.scripts.schema import Engine, LinalgOpSample

_LINALG_OP = re.compile(r"\blinalg\.([a-z_0-9]+)\b")
# proc id -> engine, matches the NAIL.unit target type in extracted modules.
_PROC = re.compile(r"proc\s*:\s*(\d+)")
_ENGINE_OF_PROC = {0: "scalar", 1: "ve", 2: "me"}


def region_body(module_text: str) -> Optional[str]:
    """Return the op text between the NAIL.unit '{' and its 'NAIL.yield'."""
    lines = module_text.splitlines()
    start = None
    for i, ln in enumerate(lines):
        if "NAIL.unit" in ln and ln.rstrip().endswith("{"):
            start = i + 1
            break
    if start is None:
        return None
    end = None
    for j in range(start, len(lines)):
        if "NAIL.yield" in lines[j]:
            end = j
            break
    if end is None:
        return None
    body = "\n".join(lines[start:end])
    return textwrap.dedent(body).strip("\n")


def op_name_of(body: str) -> str:
    for m in _LINALG_OP.finditer(body):
        if m.group(1) != "yield":           # skip the terminator
            return "linalg." + m.group(1)
    return "linalg.unknown"


def engine_of(module_text: str, fallback_path: Optional[Path] = None
              ) -> Optional[Engine]:
    """Engine from the filename suffix (`__ve`) or the target's proc id."""
    if fallback_path is not None:
        stem = fallback_path.stem
        for e in ("me", "ve", "scalar"):
            if stem.endswith("__" + e):
                return e  # type: ignore[return-value]
    m = _PROC.search(module_text)
    if m:
        return _ENGINE_OF_PROC.get(int(m.group(1)))  # type: ignore[return-value]
    return None


def _features(engine: Engine, body: str) -> list[float]:
    """Best-effort feature vector; empty when the body doesn't parse."""
    try:
        if engine == "me":
            ms = parse_matmul(body)
            return feature_vector_me(ms) if ms else []
        g = parse_generic(body)
        if not g:
            return []
        return feature_vector_ve(g) if engine == "ve" else feature_vector_scalar(g)
    except Exception:
        return []


def sample_from_file(mlir_path: Path, source: str) -> Optional[LinalgOpSample]:
    """Build a LinalgOpSample from one extracted `.mlir` file."""
    text = mlir_path.read_text()
    engine = engine_of(text, mlir_path)
    if engine is None:
        return None
    body = region_body(text)
    if not body:
        return None
    rhash = region_hash(body)
    return LinalgOpSample(
        uid=mlir_path.stem,
        engine=engine,
        op_name=op_name_of(body),
        region_mlir=body,
        region_hash=rhash,
        features=_features(engine, body),
        label_cycles=None,
        meta={"source": "realworld", "benchmark": source,
              "featurized": bool(_features(engine, body))},
    )
