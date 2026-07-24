module {
  func.func @kernel(%arg0: tensor<4x4x14xf32>, %arg1: tensor<4x14x4xf32>) -> tensor<4x14x4xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4x14x4xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<4x4x14xf32>) outs(%arg1 : tensor<4x14x4xf32>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<4x14x4xf32>
    }
    return %r : tensor<4x14x4xf32>
  }
}
