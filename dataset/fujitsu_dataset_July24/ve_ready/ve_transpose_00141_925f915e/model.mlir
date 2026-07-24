module {
  func.func @kernel(%arg0: tensor<6x12xf16>, %arg1: tensor<12x6xf16>) -> tensor<12x6xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<12x6xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<6x12xf16>) outs(%arg1 : tensor<12x6xf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<12x6xf16>
    }
    return %r : tensor<12x6xf16>
  }
}
