module {
  func.func @kernel(%arg0: tensor<27x4x17x5xi8>, %arg1: tensor<27x4x5x17xi8>) -> tensor<27x4x5x17xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<27x4x5x17xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<27x4x17x5xi8>) outs(%arg1 : tensor<27x4x5x17xi8>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<27x4x5x17xi8>
    }
    return %r : tensor<27x4x5x17xi8>
  }
}
