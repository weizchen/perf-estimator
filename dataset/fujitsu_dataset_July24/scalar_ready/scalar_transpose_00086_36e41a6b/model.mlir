module {
  func.func @kernel(%arg0: tensor<11x11x13x34xf16>, %arg1: tensor<11x11x34x13xf16>) -> tensor<11x11x34x13xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<11x11x34x13xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<11x11x13x34xf16>) outs(%arg1 : tensor<11x11x34x13xf16>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<11x11x34x13xf16>
    }
    return %r : tensor<11x11x34x13xf16>
  }
}
