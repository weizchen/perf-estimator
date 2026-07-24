module {
  func.func @kernel(%arg0: tensor<2x1984x768xf32>, %arg1: tensor<2x768x320xf32>, %arg2: tensor<2x1984x320xf32>) -> tensor<2x1984x320xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x1984x320xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x1984x768xf32>, tensor<2x768x320xf32>) outs(%arg2 : tensor<2x1984x320xf32>) -> tensor<2x1984x320xf32>
      NAIL.yield %z : tensor<2x1984x320xf32>
    }
    return %r : tensor<2x1984x320xf32>
  }
}
