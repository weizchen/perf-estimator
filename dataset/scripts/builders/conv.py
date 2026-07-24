"""Synthetic 2-D convolution corpus builder (linalg.conv_2d_nhwc_hwcf).

Lowering reality (verified by flipping `proc` and compiling to llvm-ir):

  * ME (proc 2)     -> FAILS: 'dispatch.bind' op could not lower ... conv.
                       The Matrix Engine only has a matmul kernel; conv has no
                       ME lowering. This builder can emit a proc:2 example on
                       request purely to reproduce that error.
  * VE (proc 1)     -> FAILS under the upgraded compiler (conv does not
                       vectorize on VE: 'dispatch.bind' could not lower).
  * Scalar (proc 0) -> lowers (linalg-to-loops scalar code).

So the *usable* conv corpus is Scalar-only now, over the scalar matmul-precision
set {i8, f16, f32} (i8 accumulates i32; RISC-V has no BF16/FP8). conv2d is in
no engine's `supported_ops`, so the build driver routes it to
`corpus/extras/scalar/` as a retained fallback lowering.

Knobs (PLAN corpus design): input H=W log-uniform [8,64]; filter {1,3,5,7};
in/out channels log-uniform [1,64]; stride {1,2}; no padding (valid).

OPEN QUESTION for Fujitsu (Stephen): these dims are NOT aligned to the systolic
array edge, unlike the matmul-family builders (see `policy.align_dim`).  Matmul
is aligned everywhere because applications pad up front for the ME.  conv is a
matrix op too once it is im2col'd (an [N*OH*OW, Kh*Kw*Cin] x [Kh*Kw*Cin, Cout]
GEMM), so the same application-level padding argument may apply to Cin/Cout --
but conv has no ME lowering at all today, it only ever runs on the scalar core,
and no one has said conv operands are padded.  Left unaligned pending an answer;
if the answer is "yes", align Cin/Cout (and possibly OH*OW) via `align_dim`.
"""

from __future__ import annotations

import random
from pathlib import Path

from dataset.scripts.canonicalize import region_hash
from dataset.scripts.features import feature_vector_conv, parse_conv
from dataset.scripts.policy import MATMUL_DTYPES
from dataset.scripts.schema import PROC_OF_ENGINE, LinalgOpSample

_FILTERS = [1, 3, 5, 7]
_STRIDES = [1, 2]


def _log_uniform(rng: random.Random, lo: int, hi: int) -> int:
    import math
    return max(lo, min(hi, int(2 ** rng.uniform(math.log2(lo), math.log2(hi)))))


def _conv_module(N, H, W, Cin, Kh, Kw, Cout, stride, dtype, proc):
    OH = (H - Kh) // stride + 1
    OW = (W - Kw) // stride + 1
    acc = "i32" if dtype == "i8" else "f32"
    img = f"tensor<{N}x{H}x{W}x{Cin}x{dtype}>"
    flt = f"tensor<{Kh}x{Kw}x{Cin}x{Cout}x{dtype}>"
    out = f"tensor<{N}x{OH}x{OW}x{Cout}x{acc}>"
    attrs = (f"{{dilations = dense<1> : tensor<2xi64>, "
             f"strides = dense<{stride}> : tensor<2xi64>}}")
    body = (
        f"    %c = linalg.conv_2d_nhwc_hwcf {attrs} "
        f"ins(%arg0, %arg1 : {img}, {flt}) outs(%arg2 : {out}) -> {out}\n"
    )
    module = (
        "module {\n"
        f"  func.func @kernel(%arg0: {img}, %arg1: {flt}, %arg2: {out}) -> {out} {{\n"
        f"    %r = NAIL.unit {{schedule = 0 : i64}} : "
        f"!NAIL.target<i : 0, j : 0, proc : {proc}> -> {out} {{\n"
        f"  {body}"
        f"      NAIL.yield %c : {out}\n"
        f"    }}\n"
        f"    return %r : {out}\n"
        "  }\n}\n"
    )
    return module, body.strip(), (OH, OW)


def build_conv_corpus(out_dir: Path, n_samples: int, seed: int = 0,
                      engine: str = "scalar",
                      dtypes: list[str] | None = None) -> int:
    rng = random.Random(seed)
    proc = PROC_OF_ENGINE[engine]
    dtypes = dtypes or MATMUL_DTYPES[engine]
    out_dir.mkdir(parents=True, exist_ok=True)
    seen: set[str] = set()
    written = 0
    attempts = 0
    while written < n_samples and attempts < n_samples * 6:
        attempts += 1
        Kh = Kw = rng.choice(_FILTERS)
        stride = rng.choice(_STRIDES)
        H = W = _log_uniform(rng, max(8, Kh), 64)
        if (H - Kh) // stride + 1 < 1:
            continue
        Cin = _log_uniform(rng, 1, 64)
        Cout = _log_uniform(rng, 1, 64)
        dtype = rng.choice(dtypes)
        module_text, body_text, _ = _conv_module(
            1, H, W, Cin, Kh, Kw, Cout, stride, dtype, proc)
        rhash = region_hash(body_text)
        if rhash in seen:
            continue
        seen.add(rhash)
        shape = parse_conv(body_text)
        if shape is None:
            continue
        feats = feature_vector_conv(shape)
        uid = f"{engine}_conv_{written:05d}_{rhash[:8]}"
        (out_dir / f"{uid}.mlir").write_text(module_text)
        LinalgOpSample(
            uid=uid, engine=engine, op_name="linalg.conv_2d_nhwc_hwcf",
            region_mlir=body_text, region_hash=rhash, features=feats,
            label_cycles=None,
            meta={"H": H, "W": W, "Cin": Cin, "Cout": Cout, "Kh": Kh, "Kw": Kw,
                  "stride": stride, "dtype": dtype, "source": "synthetic"},
        ).write(out_dir / f"{uid}.json")
        written += 1
    return written


def main(argv: list[str] | None = None) -> int:
    import argparse
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--out", type=Path, default=None)
    ap.add_argument("--engine", choices=["ve", "scalar", "me"], default="scalar")
    ap.add_argument("--n", type=int, default=300)
    ap.add_argument("--seed", type=int, default=0)
    args = ap.parse_args(argv)
    out = args.out or Path("dataset/corpus") / args.engine
    n = build_conv_corpus(out, args.n, args.seed, args.engine)
    print(f"wrote {n} conv ({args.engine}) samples to {out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
