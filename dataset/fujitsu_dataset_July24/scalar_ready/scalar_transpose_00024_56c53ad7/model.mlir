module {
  func.func @kernel(%arg0: tensor<18x4x20xi8>, %arg1: tensor<20x4x18xi8>) -> tensor<20x4x18xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<20x4x18xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<18x4x20xi8>) outs(%arg1 : tensor<20x4x18xi8>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<20x4x18xi8>
    }
    return %r : tensor<20x4x18xi8>
  }
}
