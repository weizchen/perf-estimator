module {
  func.func @kernel(%arg0: tensor<14x4x32xi16>, %arg1: tensor<14x32x4xi16>) -> tensor<14x32x4xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<14x32x4xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<14x4x32xi16>) outs(%arg1 : tensor<14x32x4xi16>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<14x32x4xi16>
    }
    return %r : tensor<14x32x4xi16>
  }
}
