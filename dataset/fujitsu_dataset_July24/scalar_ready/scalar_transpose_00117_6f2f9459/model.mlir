module {
  func.func @kernel(%arg0: tensor<148x5xi8>, %arg1: tensor<5x148xi8>) -> tensor<5x148xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<5x148xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<148x5xi8>) outs(%arg1 : tensor<5x148xi8>) permutation = [1, 0]
      NAIL.yield %z : tensor<5x148xi8>
    }
    return %r : tensor<5x148xi8>
  }
}
