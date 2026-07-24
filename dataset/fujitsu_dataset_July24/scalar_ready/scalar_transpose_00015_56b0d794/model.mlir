module {
  func.func @kernel(%arg0: tensor<33x21x35xi16>, %arg1: tensor<33x35x21xi16>) -> tensor<33x35x21xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<33x35x21xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<33x21x35xi16>) outs(%arg1 : tensor<33x35x21xi16>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<33x35x21xi16>
    }
    return %r : tensor<33x35x21xi16>
  }
}
