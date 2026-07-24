module {
  func.func @kernel(%arg0: tensor<181x108xi16>, %arg1: tensor<108x181xi16>) -> tensor<108x181xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<108x181xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<181x108xi16>) outs(%arg1 : tensor<108x181xi16>) permutation = [1, 0]
      NAIL.yield %z : tensor<108x181xi16>
    }
    return %r : tensor<108x181xi16>
  }
}
