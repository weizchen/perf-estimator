module {
  func.func @kernel(%arg0: tensor<11x4xf32>, %arg1: tensor<4x11xf32>) -> tensor<4x11xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x11xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<11x4xf32>) outs(%arg1 : tensor<4x11xf32>) permutation = [1, 0]
      NAIL.yield %z : tensor<4x11xf32>
    }
    return %r : tensor<4x11xf32>
  }
}
