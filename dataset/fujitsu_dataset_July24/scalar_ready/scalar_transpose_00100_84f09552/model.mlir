module {
  func.func @kernel(%arg0: tensor<108x5x7xf16>, %arg1: tensor<108x7x5xf16>) -> tensor<108x7x5xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<108x7x5xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<108x5x7xf16>) outs(%arg1 : tensor<108x7x5xf16>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<108x7x5xf16>
    }
    return %r : tensor<108x7x5xf16>
  }
}
