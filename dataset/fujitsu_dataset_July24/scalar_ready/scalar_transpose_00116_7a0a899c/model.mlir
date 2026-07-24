module {
  func.func @kernel(%arg0: tensor<13x13x13x43xf16>, %arg1: tensor<13x13x43x13xf16>) -> tensor<13x13x43x13xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<13x13x43x13xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<13x13x13x43xf16>) outs(%arg1 : tensor<13x13x43x13xf16>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<13x13x43x13xf16>
    }
    return %r : tensor<13x13x43x13xf16>
  }
}
