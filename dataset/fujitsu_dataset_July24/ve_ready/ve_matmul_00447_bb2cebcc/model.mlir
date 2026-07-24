module {
  func.func @kernel(%arg0: tensor<256x1856xf32>, %arg1: tensor<1856x3392xf32>, %arg2: tensor<256x3392xf32>) -> tensor<256x3392xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<256x3392xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x1856xf32>, tensor<1856x3392xf32>) outs(%arg2 : tensor<256x3392xf32>) -> tensor<256x3392xf32>
      NAIL.yield %m : tensor<256x3392xf32>
    }
    return %r : tensor<256x3392xf32>
  }
}
