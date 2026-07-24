module {
  func.func @kernel(%arg0: tensor<6x13x4x5xi16>, %arg1: tensor<6x13x5x4xi16>) -> tensor<6x13x5x4xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<6x13x5x4xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<6x13x4x5xi16>) outs(%arg1 : tensor<6x13x5x4xi16>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<6x13x5x4xi16>
    }
    return %r : tensor<6x13x5x4xi16>
  }
}
