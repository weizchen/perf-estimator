// Bare named `linalg.softmax` (no NAIL wrapper).
//
// Used to show that `--linalg-generalize-named-ops` is a no-op on softmax
// (softmax is an *aggregate* op, not a generalizable named contraction/conv).
//
//   ofa-opt softmax.mlir --linalg-generalize-named-ops
//   -> the op is unchanged (still linalg.softmax).

func.func @main(%a: tensor<8x16xf32>, %o: tensor<8x16xf32>) -> tensor<8x16xf32> {
  %0 = linalg.softmax dimension(1)
         ins(%a : tensor<8x16xf32>) outs(%o : tensor<8x16xf32>) -> tensor<8x16xf32>
  return %0 : tensor<8x16xf32>
}
