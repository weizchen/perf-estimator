module {
  func.func @kernel(%arg0: tensor<68x4x6xi16>, %arg1: tensor<4x68x6xi16>) -> tensor<4x68x6xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x68x6xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<68x4x6xi16>) outs(%arg1 : tensor<4x68x6xi16>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<4x68x6xi16>
    }
    return %r : tensor<4x68x6xi16>
  }
}
