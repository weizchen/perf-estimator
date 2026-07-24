module {
  func.func @kernel(%arg0: tensor<6x13x13x13xf16>, %arg1: tensor<6x13x13x13xf16>) -> tensor<6x13x13x13xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<6x13x13x13xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<6x13x13x13xf16>) outs(%arg1 : tensor<6x13x13x13xf16>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<6x13x13x13xf16>
    }
    return %r : tensor<6x13x13x13xf16>
  }
}
