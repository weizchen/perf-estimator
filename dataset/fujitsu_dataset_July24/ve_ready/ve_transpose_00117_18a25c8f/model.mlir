module {
  func.func @kernel(%arg0: tensor<10x12x16x8xf16>, %arg1: tensor<10x8x16x12xf16>) -> tensor<10x8x16x12xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<10x8x16x12xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<10x12x16x8xf16>) outs(%arg1 : tensor<10x8x16x12xf16>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<10x8x16x12xf16>
    }
    return %r : tensor<10x8x16x12xf16>
  }
}
