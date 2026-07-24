module {
  func.func @kernel(%arg0: tensor<18x31x15xi16>, %arg1: tensor<15x31x18xi16>) -> tensor<15x31x18xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<15x31x18xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<18x31x15xi16>) outs(%arg1 : tensor<15x31x18xi16>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<15x31x18xi16>
    }
    return %r : tensor<15x31x18xi16>
  }
}
