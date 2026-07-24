module {
  func.func @kernel(%arg0: tensor<24x16xi16>, %arg1: tensor<16x24xi16>) -> tensor<16x24xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<16x24xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<24x16xi16>) outs(%arg1 : tensor<16x24xi16>) permutation = [1, 0]
      NAIL.yield %z : tensor<16x24xi16>
    }
    return %r : tensor<16x24xi16>
  }
}
