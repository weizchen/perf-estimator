module {
  func.func @kernel(%arg0: tensor<23x37x19x10xi16>, %arg1: tensor<23x10x19x37xi16>) -> tensor<23x10x19x37xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<23x10x19x37xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<23x37x19x10xi16>) outs(%arg1 : tensor<23x10x19x37xi16>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<23x10x19x37xi16>
    }
    return %r : tensor<23x10x19x37xi16>
  }
}
