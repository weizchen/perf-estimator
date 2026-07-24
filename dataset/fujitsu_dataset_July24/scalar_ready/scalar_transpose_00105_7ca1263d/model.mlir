module {
  func.func @kernel(%arg0: tensor<17x166xi16>, %arg1: tensor<166x17xi16>) -> tensor<166x17xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<166x17xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<17x166xi16>) outs(%arg1 : tensor<166x17xi16>) permutation = [1, 0]
      NAIL.yield %z : tensor<166x17xi16>
    }
    return %r : tensor<166x17xi16>
  }
}
