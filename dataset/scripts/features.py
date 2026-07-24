"""Feature vectorization for the three per-engine corpora.

Each engine has its own featurizer that parses a single linalg op's region
text and produces a fixed-length feature vector. The trainer picks the right
featurizer based on the sample's `engine` field.

ME: matmul shape (18-d). VE: vector length + chain depth + op-class (22-d).
Scalar: loop nest + body size + op-class (20-d). The dtype one-hot is the
6-way union of every per-engine precision the arch JSONs list.
"""

from __future__ import annotations

import math
import re
from typing import NamedTuple, Optional

from dataset.scripts.policy import align_dim

# Dtype one-hot, union of every per-engine precision the arch JSONs list:
#   ME  inputs: INT8, FP8, FP16, BF16
#   VE  inputs: FP32, FP16, BF16, INT32, INT16, INT8
#   RISC-V    : FP32, FP16, INT32, INT16, INT8   (no BF16, no FP8)
# (INT32 is only ever an accumulator here, so it isn't a standalone input slot.)
_DTYPES = ["f8E5M2", "bf16", "f16", "f32", "i8", "i16"]


# ----- ME (linalg.matmul) ----------------------------------------------------

# linalg.matmul ins(%a, %b : tensor<MxKxDT>, tensor<KxNxDT>) outs(%c : tensor<MxNxACC>)
_MATMUL = re.compile(
    r"linalg\.matmul\s+ins\([^:]+:\s*"
    r"tensor<(\d+)x(\d+)x([A-Za-z0-9]+)>,\s*"
    r"tensor<(\d+)x(\d+)x([A-Za-z0-9]+)>\)\s*outs\([^:]+:\s*"
    r"tensor<(\d+)x(\d+)x([A-Za-z0-9]+)>"
)


class MatmulShape(NamedTuple):
    M: int
    N: int
    K: int
    dtype: str          # input element type
    acc: str            # accumulator/output element type


def parse_matmul(region_mlir: str) -> Optional[MatmulShape]:
    m = _MATMUL.search(region_mlir)
    if not m:
        return None
    a0, a1, adt, b0, b1, bdt, c0, c1, cdt = m.groups()
    return MatmulShape(M=int(a0), K=int(a1), N=int(b1), dtype=adt, acc=cdt)


def feature_vector_me(s: MatmulShape) -> list[float]:
    """18-d ME feature vector.

    Tile counts and padding waste are measured against the *mode's* systolic
    array edge -- 128x128 for INT8/FP8, 64x64 for FP16/BF16 -- not a fixed 128.
    """
    M, N, K = s.M, s.N, s.K
    dim = align_dim(s.dtype)
    tiles_m = math.ceil(M / dim)
    tiles_n = math.ceil(N / dim)
    onehot = [1.0 if s.dtype == d else 0.0 for d in _DTYPES]
    acc_is_f32 = 1.0 if s.acc == "f32" else 0.0
    return [
        float(M), float(N), float(K),
        math.log2(M + 1), math.log2(N + 1), math.log2(K + 1),
        math.log2(M * N * K + 1),
        *onehot,                       # 6
        float(tiles_m), float(tiles_n),
        float(tiles_m * dim - M),      # pad rows (0 once dims are aligned)
        float(tiles_n * dim - N),      # pad cols
        acc_is_f32,                    # FP32/INT32 accum vs FP16 accum
    ]


ME_FEATURE_DIM = 18   # 12 shape/log/tile features + 6-way dtype one-hot


# ----- Conv (linalg.conv_2d_nhwc_hwcf) ---------------------------------------

# conv_2d_nhwc_hwcf ins(%img, %flt : tensor<NxHxWxCxDT>, tensor<KhxKwxCxFxDT>)
#                   outs(%o : tensor<NxOHxOWxFxACC>)
_CONV = re.compile(
    r"linalg\.conv_2d_nhwc_hwcf\s+(?:\{[^}]*\}\s+)?ins\([^:]+:\s*"
    r"tensor<(\d+)x(\d+)x(\d+)x(\d+)x([A-Za-z0-9]+)>,\s*"
    r"tensor<(\d+)x(\d+)x(\d+)x(\d+)x([A-Za-z0-9]+)>\)\s*outs\([^:]+:\s*"
    r"tensor<(\d+)x(\d+)x(\d+)x(\d+)x([A-Za-z0-9]+)>"
)


class ConvShape(NamedTuple):
    N: int
    H: int
    W: int
    Cin: int
    Kh: int
    Kw: int
    Cout: int
    OH: int
    OW: int
    stride: int
    dtype: str
    acc: str


def parse_conv(region_mlir: str) -> Optional[ConvShape]:
    m = _CONV.search(region_mlir)
    if not m:
        return None
    (n, h, w, c, dt, kh, kw, c2, f, _fdt, on, oh, ow, of, acc) = m.groups()
    H, Kh, OH = int(h), int(kh), int(oh)
    stride = max(1, (H - Kh) // max(1, OH - 1)) if OH > 1 else 1
    return ConvShape(N=int(n), H=H, W=int(w), Cin=int(c), Kh=Kh, Kw=int(kw),
                     Cout=int(f), OH=OH, OW=int(ow), stride=stride,
                     dtype=dt, acc=acc)


def feature_vector_conv(s: ConvShape) -> list[float]:
    """18-d conv feature vector."""
    out_elems = s.N * s.OH * s.OW * s.Cout
    macs = out_elems * s.Kh * s.Kw * s.Cin
    onehot = [1.0 if s.dtype == d else 0.0 for d in _DTYPES]
    return [
        float(s.H), float(s.W), float(s.Cin), float(s.Cout),
        float(s.Kh), float(s.Kw), float(s.stride),
        math.log2(s.H * s.W + 1), math.log2(s.Cin + 1), math.log2(s.Cout + 1),
        math.log2(out_elems + 1), math.log2(macs + 1),
        *onehot,                       # 6
    ]


CONV_FEATURE_DIM = 18


# ----- VE (linalg.generic, elementwise + reduction) --------------------------

# A simple `linalg.generic` body the builder emits looks like:
#   linalg.generic { ..., iterator_types = ["parallel"] } ins(%a : tensor<Nxf32>) outs(...)
# or for reduction:
#   linalg.generic { ..., iterator_types = ["reduction"] } ins(%a : tensor<Nxf32>) outs(%out : tensor<f32>)
_GENERIC_INS = re.compile(
    r"linalg\.generic\b[^{]*\{[^}]*iterator_types\s*=\s*\[([^\]]+)\][^}]*\}"
    r"[^:]*ins\(([^:]+):\s*([^)]+)\)"
)
_TENSOR_SHAPE = re.compile(r"tensor<([^>]+)>")
# Count both arith.* and math.* ops toward chain depth (transcendentals are math.*).
_BODY_OP = re.compile(r"(?:arith|math)\.[a-z0-9]+")

# Operation-class multi-hot, so the model can tell transcendentals (costly on the
# VE special-function unit) from cheap arith. A class is set when any of its
# tokens appears in the op body.
_FN_TOKENS = {
    "add":   ("arith.addf", "arith.addi"),
    "mul":   ("arith.mulf", "arith.muli"),
    "max":   ("arith.maximumf", "arith.maxsi"),
    "div":   ("arith.divf",),
    "exp":   ("math.exp",),
    "tanh":  ("math.tanh",),
    "rsqrt": ("math.rsqrt",),
    "sqrt":  ("math.sqrt",),
}
_FN_CLASSES = list(_FN_TOKENS)
_OP_HOT_DIM = len(_FN_CLASSES)   # 8


def _op_multihot(region_mlir: str) -> tuple[float, ...]:
    return tuple(1.0 if any(t in region_mlir for t in toks) else 0.0
                 for toks in _FN_TOKENS.values())


class GenericShape(NamedTuple):
    n_elems: int        # total elements in the largest operand
    n_parallel: int     # number of parallel iterators
    n_reduction: int    # number of reduction iterators
    dtype: str
    chain_depth: int    # number of arith/math ops in the body
    op_hot: tuple = (0.0,) * _OP_HOT_DIM   # op-class multi-hot


def _largest_tensor_size(tensor_decls: str) -> tuple[int, str]:
    """Return (max element count, dtype) across the listed tensor types."""
    best_n = 1
    best_dt = "f32"
    for tm in _TENSOR_SHAPE.finditer(tensor_decls):
        parts = tm.group(1).split("x")
        *dims, dt = parts
        try:
            n = 1
            for d in dims:
                n *= int(d)
        except ValueError:
            continue
        if n >= best_n:
            best_n = n
            best_dt = dt
    return best_n, best_dt


def parse_generic(region_mlir: str) -> Optional[GenericShape]:
    m = _GENERIC_INS.search(region_mlir)
    if not m:
        return None
    iter_types = [t.strip().strip('"') for t in m.group(1).split(",")]
    n_par = sum(1 for t in iter_types if t == "parallel")
    n_red = sum(1 for t in iter_types if t == "reduction")
    n_elems, dtype = _largest_tensor_size(m.group(3))
    chain = len(_BODY_OP.findall(region_mlir))
    return GenericShape(n_elems=n_elems, n_parallel=n_par, n_reduction=n_red,
                        dtype=dtype, chain_depth=max(1, chain),
                        op_hot=_op_multihot(region_mlir))


def feature_vector_ve(s: GenericShape) -> list[float]:
    """22-d VE feature vector (14 shape/dtype + 8 op-class multi-hot)."""
    onehot = [1.0 if s.dtype == d else 0.0 for d in _DTYPES]
    return [
        float(s.n_elems),
        math.log2(s.n_elems + 1),
        float(s.n_parallel),
        float(s.n_reduction),
        float(s.chain_depth),
        math.log2(s.chain_depth + 1),
        *onehot,                       # 6
        1.0 if s.n_reduction > 0 else 0.0,    # is_reduction
        math.ceil(s.n_elems / 16),     # rough vec-lane count (placeholder VLEN)
        *s.op_hot,                     # 8: op-class multi-hot
    ]


VE_FEATURE_DIM = 22


# ----- Scalar (any linalg op, lowered to scf+arith) --------------------------

def feature_vector_scalar(s: GenericShape) -> list[float]:
    """20-d scalar feature vector (12 shape/dtype + 8 op-class multi-hot)."""
    nest = s.n_parallel + s.n_reduction
    onehot = [1.0 if s.dtype == d else 0.0 for d in _DTYPES]
    return [
        float(nest),
        float(s.n_elems),
        math.log2(s.n_elems + 1),
        float(s.chain_depth),
        math.log2(s.chain_depth + 1),
        *onehot,                       # 6
        1.0,                           # stride_kind == sequential (placeholder)
        *s.op_hot,                     # 8: op-class multi-hot
    ]


SCALAR_FEATURE_DIM = 20


# ----- Contraction family (batch_matmul / matvec / vecmat) -------------------
# Featurized from known shapes (the builders pass them in), since these are
# structured ops with no free-form body to parse.

_CONTRACTION_KINDS = ["matmul", "batch_matmul", "matvec", "vecmat"]


def feature_vector_contraction(kind: str, B: int, M: int, K: int, N: int,
                               dtype: str, acc: str = "f32") -> list[float]:
    """20-d contraction feature vector.

    `acc_is_wide` separates a widening accumulator (FP32/INT32) from a narrow
    same-width one (FP16), which halves output traffic; without it f16->f32 and
    f16->f16 would be indistinguishable.
    """
    kind_hot = [1.0 if kind == k else 0.0 for k in _CONTRACTION_KINDS]   # 4
    dt_hot = [1.0 if dtype == d else 0.0 for d in _DTYPES]               # 6
    flops = max(1, B * M * K * N)
    acc_is_wide = 1.0 if acc in ("f32", "i32") else 0.0
    return [
        float(B), float(M), float(K), float(N),
        math.log2(B + 1), math.log2(M + 1), math.log2(K + 1), math.log2(N + 1),
        math.log2(flops + 1), acc_is_wide,
        *kind_hot, *dt_hot,
    ]


CONTRACTION_FEATURE_DIM = 10 + len(_CONTRACTION_KINDS) + len(_DTYPES)   # 20


# ----- Transpose (memory-bound permutation) ----------------------------------

_TRANSPOSE_MAXRANK = 4


def feature_vector_transpose(in_shape: list[int], perm: list[int],
                             dtype: str) -> list[float]:
    """17-d transpose feature vector: rank, size, padded dims + permutation."""
    rank = len(in_shape)
    elems = 1
    for d in in_shape:
        elems *= d
    dims = (list(in_shape) + [1] * _TRANSPOSE_MAXRANK)[:_TRANSPOSE_MAXRANK]
    perm_pad = (list(perm) + [0] * _TRANSPOSE_MAXRANK)[:_TRANSPOSE_MAXRANK]
    dt_hot = [1.0 if dtype == d else 0.0 for d in _DTYPES]              # 6
    return [
        float(rank), float(elems), math.log2(elems + 1),
        *[float(x) for x in dims],          # 4
        *[float(x) for x in perm_pad],      # 4
        *dt_hot,
    ]


TRANSPOSE_FEATURE_DIM = 3 + 2 * _TRANSPOSE_MAXRANK + len(_DTYPES)      # 17


# ----- Structured Tier-2 ops (reduce/broadcast/copy/elementwise/select) ------
# Shared featurizer; the op family is encoded in a one-hot (the trainer groups
# by op_name, so the shared dim is fine). Featurized from known shapes.

_STRUCTURED_KINDS = ["reduce", "broadcast", "copy", "elementwise", "select"]


def feature_vector_structured(op_kind: str, in_elems: int, out_elems: int,
                              rank: int, n_inputs: int, dtype: str) -> list[float]:
    """18-d feature vector for the structured Tier-2 ops."""
    kind_hot = [1.0 if op_kind == k else 0.0 for k in _STRUCTURED_KINDS]   # 5
    dt_hot = [1.0 if dtype == d else 0.0 for d in _DTYPES]                 # 6
    return [
        float(in_elems), math.log2(in_elems + 1),
        float(out_elems), math.log2(out_elems + 1),
        float(rank), float(n_inputs),
        math.log2(max(1, out_elems) / max(1, in_elems) + 1),   # broadcast/reduce ratio
        *kind_hot, *dt_hot,
    ]


STRUCTURED_FEATURE_DIM = 7 + len(_STRUCTURED_KINDS) + len(_DTYPES)    # 18


# ----- Backwards-compat alias (some tests import this) -----------------------
# `feature_vector` previously meant the ME flavor.
feature_vector = feature_vector_me
FEATURE_DIM = ME_FEATURE_DIM
