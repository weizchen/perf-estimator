module {
  func.func @kernel(%arg0: tensor<435x5xi16>, %arg1: tensor<5x435xi16>) -> tensor<5x435xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<5x435xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<435x5xi16>) outs(%arg1 : tensor<5x435xi16>) permutation = [1, 0]
      NAIL.yield %z : tensor<5x435xi16>
    }
    return %r : tensor<5x435xi16>
  }
}
