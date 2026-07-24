module {
  func.func @kernel(%arg0: tensor<4x10x14x12xi16>, %arg1: tensor<4x10x12x14xi16>) -> tensor<4x10x12x14xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x10x12x14xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<4x10x14x12xi16>) outs(%arg1 : tensor<4x10x12x14xi16>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<4x10x12x14xi16>
    }
    return %r : tensor<4x10x12x14xi16>
  }
}
