module {
  func.func @kernel(%arg0: tensor<23x28x18x18xi16>, %arg1: tensor<23x28x18x18xi16>) -> tensor<23x28x18x18xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<23x28x18x18xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<23x28x18x18xi16>) outs(%arg1 : tensor<23x28x18x18xi16>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<23x28x18x18xi16>
    }
    return %r : tensor<23x28x18x18xi16>
  }
}
