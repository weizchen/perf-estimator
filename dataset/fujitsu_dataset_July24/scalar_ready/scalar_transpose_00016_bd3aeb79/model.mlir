module {
  func.func @kernel(%arg0: tensor<139x7xf16>, %arg1: tensor<7x139xf16>) -> tensor<7x139xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<7x139xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<139x7xf16>) outs(%arg1 : tensor<7x139xf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<7x139xf16>
    }
    return %r : tensor<7x139xf16>
  }
}
