module {
  func.func @kernel(%arg0: tensor<12x14x4x39xi8>, %arg1: tensor<12x4x14x39xi8>) -> tensor<12x4x14x39xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<12x4x14x39xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<12x14x4x39xi8>) outs(%arg1 : tensor<12x4x14x39xi8>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<12x4x14x39xi8>
    }
    return %r : tensor<12x4x14x39xi8>
  }
}
