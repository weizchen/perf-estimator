module {
  func.func @kernel(%arg0: tensor<2x768x192xf32>, %arg1: tensor<2x192x384xf32>, %arg2: tensor<2x768x384xf32>) -> tensor<2x768x384xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x768x384xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x768x192xf32>, tensor<2x192x384xf32>) outs(%arg2 : tensor<2x768x384xf32>) -> tensor<2x768x384xf32>
      NAIL.yield %z : tensor<2x768x384xf32>
    }
    return %r : tensor<2x768x384xf32>
  }
}
