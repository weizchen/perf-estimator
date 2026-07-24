module {
  func.func @kernel(%arg0: tensor<35x10x7xf16>, %arg1: tensor<35x7x10xf16>) -> tensor<35x7x10xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<35x7x10xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<35x10x7xf16>) outs(%arg1 : tensor<35x7x10xf16>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<35x7x10xf16>
    }
    return %r : tensor<35x7x10xf16>
  }
}
