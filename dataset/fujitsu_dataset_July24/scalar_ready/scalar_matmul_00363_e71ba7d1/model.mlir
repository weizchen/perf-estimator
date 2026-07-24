module {
  func.func @kernel(%arg0: tensor<64x1728xf32>, %arg1: tensor<1728x320xf32>, %arg2: tensor<64x320xf32>) -> tensor<64x320xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<64x320xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x1728xf32>, tensor<1728x320xf32>) outs(%arg2 : tensor<64x320xf32>) -> tensor<64x320xf32>
      NAIL.yield %m : tensor<64x320xf32>
    }
    return %r : tensor<64x320xf32>
  }
}
