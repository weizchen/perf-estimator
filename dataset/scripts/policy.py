"""Per-engine spec policy, derived from the OFA arch JSONs (targets/Processors).

Two things the corpus has to respect, both read straight off the upgraded
target specs:

1. Precision matrices (``supported_input_precisions`` / the ME ``input/accum``
   table).  Each engine only accepts a subset of dtypes:

     ME      INT8, FP8, FP16, BF16          (no FP32 input, no INT16)
     VE      FP32, FP16, BF16, INT32/16/8
     RISC-V  FP32, FP16, INT32/16/8         (no BF16, no FP8)

   ``MATMUL_DTYPES`` / ``GENERIC_DTYPES`` encode the subsets we actually
   generate per family (INT32 is only ever an accumulator, so it is not a
   standalone input dtype; matmul stays on the common ML dtypes and skips the
   integer-16 corner the arithmetic-heavy generic family covers instead).

2. ``policies.supported_ops`` per engine:

     ME      [matmul]
     VE      [elementwise, reduction, matmul]
     RISC-V  [elementwise, reduction, scalar]

   ``spec_supported`` replicates the compiler's own ``categoryOf`` bucketing
   (Matmul / Conv2d / Reduction / Elementwise) and tests membership.  Ops that
   lower on an engine but fall outside its ``supported_ops`` (matmul/conv on the
   scalar core) are *retained* — they're real fallback lowerings — but routed to
   ``corpus/extras/<engine>/`` and tagged ``spec_supported=false`` so it is
   obvious what is kept beyond spec.
"""

from __future__ import annotations

from typing import Any

# ----- precision subsets per op family --------------------------------------

# Matmul stays on the common ML dtypes each engine's datapath accepts.
MATMUL_DTYPES: dict[str, list[str]] = {
    "me": ["i8", "f8E5M2", "bf16", "f16"],     # no FP32 input on ME
    "ve": ["i8", "bf16", "f16", "f32"],        # no FP8 on VE
    "scalar": ["i8", "f16", "f32"],            # no BF16, no FP8 on RISC-V
}

# Arithmetic generic / elementwise / reduction families exercise the full
# integer + float precision range each engine lists.
GENERIC_DTYPES: dict[str, list[str]] = {
    "ve": ["i8", "i16", "bf16", "f16", "f32"],
    "scalar": ["i8", "i16", "f16", "f32"],     # no BF16 on RISC-V
}

# Float-only sub-set (transcendentals / div) of the generic families.
FLOAT_DTYPES: dict[str, list[str]] = {
    "ve": ["bf16", "f16", "f32"],
    "scalar": ["f16", "f32"],
}

# i8 / i16 matmul-family ops accumulate in i32; everything else in f32.
def acc_dtype(dtype: str) -> str:
    return "i32" if dtype in ("i8", "i16") else "f32"


# ----- ME systolic modes ----------------------------------------------------

# The six (input, accumulator) modes the compiler declares for the Matrix
# Engine -- targets/Processors/MatrixEngine.json "modes", matching Fujitsu's
# "Supported Data Types (ME)" slide -- with the systolic geometry each runs on
# and whether it currently works end-to-end.
#
#   i8   -> i32   lowers, but does not run: Fujitsu note "we intend to support
#                 these, but some are still missing (int8)"; INT8 also appears
#                 nowhere in the planned table (only INT4/INT2/1bit).
#   bf16 -> f32   lowers, but gem5 reports Build OK / Run FAIL.
#   bf16 -> f16   does not even lower -- `linalg.matmul` only inserts implicit
#                 accumulator casts that *widen* (f16/bf16->f32, i8->i32,
#                 f8->f32); bf16->f16 is neither same-type nor widening, so the
#                 region fails with "'arith.addf' op requires the same type for
#                 all operands and results".  Matches the planned table, where
#                 every FP16-accumulator column in the A=BF16 rows is "-".
#
# `array_dim` is the mode's spatial_dimensions edge (128x128 for INT8/FP8,
# 64x64 for FP16/BF16).  Per Stephen, matmul dimensions must be multiples of
# it; see ME_ALIGN_DIMS for which dims we align.
ME_MODES: list[tuple[str, str, int, bool, bool]] = [
    # input,    accum,  array_dim, lowers, runs_on_gem5
    ("f8E5M2",  "f32",  128,       True,   True),
    ("f16",     "f32",  64,        True,   True),
    ("f16",     "f16",  64,        True,   True),
    ("i8",      "i32",  128,       True,   False),
    ("bf16",    "f32",  64,        True,   False),
    ("bf16",    "f16",  64,        False,  False),
]

# Pack subfolder per mode: "" ships in the runnable set, anything else is
# quarantined into `<engine>_ready/<bucket>/`.
_ME_BUCKET: dict[tuple[str, str], str] = {
    ("i8", "i32"): "unsupported_i8",
    ("bf16", "f32"): "unsupported_bf16",
    ("bf16", "f16"): "unsupported_bf16_f16acc",   # does not compile
}


def me_bucket(dtype: str, acc: str) -> str:
    """Quarantine subfolder for an ME (input, accum) mode; "" if runnable."""
    if (dtype, acc) in _ME_BUCKET:
        return _ME_BUCKET[(dtype, acc)]
    if any(dtype == i and acc == a and runs for i, a, _, _, runs in ME_MODES):
        return ""
    return f"unsupported_{dtype}"        # not an ME mode at all (e.g. f32)

# Which matmul dims are constrained to a multiple of `array_dim`.  M and N are
# the array's spatial dims, so they are certainly constrained.  K is included
# because the planned table lists K=1 for every mode (i.e. a contraction
# granularity of 1, suggesting K is free) but that is not confirmed -- aligning
# it is the safe reading of "dimensions must be multiples of the array dims".
ME_ALIGN_DIMS = ("M", "K", "N")

_ME_ARRAY_DIM = {inp: dim for inp, _, dim, _, _ in ME_MODES}


# Matmul (input, accumulator) modes for the non-ME engines.  Unlike the ME,
# neither has a fixed accumulator table -- any output precision listed in its
# `supported_output_precisions` is legal -- so each input dtype gets the usual
# widening accumulator (FP32 / INT32) plus, for FP16, the narrow `f16->f16`
# variant the ME also supports (verified to lower on both engines).  BF16 is
# VE-only and has no narrow variant: `bf16->f16` cannot be expressed at all
# (linalg.matmul only inserts *widening* accumulator casts), and `bf16->bf16`
# is not generated yet.
MATMUL_MODES: dict[str, list[tuple[str, str]]] = {
    "ve":     [("i8", "i32"), ("f16", "f32"), ("f16", "f16"),
               ("bf16", "f32"), ("f32", "f32")],
    "scalar": [("i8", "i32"), ("f16", "f32"), ("f16", "f16"), ("f32", "f32")],
}


def align_dim(dtype: str) -> int:
    """Matmul dimension alignment granularity for a dtype.

    This is the ME's systolic array edge -- 128 for INT8/FP8, 64 for FP16/BF16
    -- and it applies to matmul-family ops on *every* engine, not just the ME.
    Per Fujitsu, matrix alignment is done at the application level by the user:
    the ME is the primary matmul engine and cannot take unaligned operands, so
    applications pad their matrices up front.  VE and the scalar core therefore
    also only ever see already-padded matrices, even though neither has a
    systolic array and both happily lower unaligned shapes.

    Dtypes the ME cannot take at all (FP32) use 64, the finest granularity the
    ME ever requires.
    """
    return _ME_ARRAY_DIM.get(dtype, 64)


# ----- supported_ops classification (mirrors NAIL categoryOf) ---------------

# policies.supported_ops, minus the "scalar" token categoryOf never emits.
_SUPPORTED_CATEGORIES: dict[str, set[str]] = {
    "me": {"matmul"},
    "ve": {"matmul", "reduction", "elementwise"},
    "scalar": {"reduction", "elementwise"},
}


def category(op_name: str, meta: dict[str, Any] | None = None) -> str:
    """Bucket an op the way the compiler's ``categoryOf`` does.

    matmul/batch_matmul -> matmul; *conv* -> conv2d; anything with a reduction
    loop (matvec/vecmat/reduce/reduction-generic) -> reduction; else
    elementwise (transpose/broadcast/copy/select/elementwise/parallel-generic).
    """
    meta = meta or {}
    base = op_name.rsplit(".", 1)[-1]
    if base in ("matmul", "batch_matmul"):
        return "matmul"
    if "conv" in base:
        return "conv2d"
    if base in ("matvec", "vecmat", "reduce"):
        return "reduction"
    if base == "generic":
        return "reduction" if meta.get("form") == "reduction" else "elementwise"
    return "elementwise"


def spec_supported(engine: str, op_name: str, meta: dict[str, Any] | None = None) -> bool:
    """True if ``op`` is in ``engine``'s declared ``supported_ops`` categories."""
    return category(op_name, meta) in _SUPPORTED_CATEGORIES[engine]


def spec_reason(engine: str, op_name: str, meta: dict[str, Any] | None = None) -> str:
    """Human-readable note for a retained out-of-spec op (for the meta tag)."""
    cat = category(op_name, meta)
    return (f"{cat} not in {engine} supported_ops "
            f"{sorted(_SUPPORTED_CATEGORIES[engine])}; kept as fallback lowering")
