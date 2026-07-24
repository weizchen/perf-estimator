module {
  func.func @kernel(%arg0: tensor<4x30x45x11xi8>, %arg1: tensor<4x11x45x30xi8>) -> tensor<4x11x45x30xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x11x45x30xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<4x30x45x11xi8>) outs(%arg1 : tensor<4x11x45x30xi8>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<4x11x45x30xi8>
    }
    return %r : tensor<4x11x45x30xi8>
  }
}
