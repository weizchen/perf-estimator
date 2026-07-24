module {
  func.func @kernel(%arg0: tensor<441x127xi16>, %arg1: tensor<127x441xi16>) -> tensor<127x441xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<127x441xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<441x127xi16>) outs(%arg1 : tensor<127x441xi16>) permutation = [1, 0]
      NAIL.yield %z : tensor<127x441xi16>
    }
    return %r : tensor<127x441xi16>
  }
}
