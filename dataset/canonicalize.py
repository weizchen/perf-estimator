"""Canonical, SSA-name + placement invariant region hashing.

The `nail-dump-units` pass emits `region_sha256` over the raw region text,
which is sensitive to the surrounding SSA value names (e.g. `%arg0` vs
`%arg3`). Two structurally identical kernels placed on different cores
therefore get different raw hashes. For dedup-before-labeling we need a hash
that collapses them.

This is the v1 approximation the PLAN explicitly assigns to this module:
regex-based SSA-identifier renumbering by first appearance. It is sufficient
to dedup structurally identical kernels (the dominant case across transformer
layers). True semantic canonicalization (operand commutativity, attribute
ordering) is out of scope for Phase 1.
"""

from __future__ import annotations

import hashlib
import re

# Matches an MLIR SSA identifier: %name or %123 (incl. %arg0).
_SSA = re.compile(r"%[A-Za-z0-9_]+")


def canonicalize_region(region_mlir: str) -> str:
    """Rename every SSA identifier to %v0, %v1, ... in first-seen order."""
    mapping: dict[str, str] = {}

    def repl(m: re.Match) -> str:
        tok = m.group(0)
        if tok not in mapping:
            mapping[tok] = f"%v{len(mapping)}"
        return mapping[tok]

    # Normalize trailing whitespace per line so cosmetic diffs don't matter.
    lines = [ln.rstrip() for ln in region_mlir.strip().splitlines()]
    return _SSA.sub(repl, "\n".join(lines))


def region_hash(region_mlir: str) -> str:
    """Stable hex digest of the canonicalized region (the dedup key)."""
    canon = canonicalize_region(region_mlir)
    return hashlib.sha256(canon.encode("utf-8")).hexdigest()
