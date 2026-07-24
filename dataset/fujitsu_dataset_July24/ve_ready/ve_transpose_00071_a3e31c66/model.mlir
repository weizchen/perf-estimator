module {
  func.func @kernel(%arg0: tensor<31x13x28x10xi16>, %arg1: tensor<31x10x28x13xi16>) -> tensor<31x10x28x13xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<31x10x28x13xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<31x13x28x10xi16>) outs(%arg1 : tensor<31x10x28x13xi16>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<31x10x28x13xi16>
    }
    return %r : tensor<31x10x28x13xi16>
  }
}
