module {
  func.func @kernel(%arg0: tensor<14x13x16x26xf16>, %arg1: tensor<14x16x13x26xf16>) -> tensor<14x16x13x26xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<14x16x13x26xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<14x13x16x26xf16>) outs(%arg1 : tensor<14x16x13x26xf16>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<14x16x13x26xf16>
    }
    return %r : tensor<14x16x13x26xf16>
  }
}
