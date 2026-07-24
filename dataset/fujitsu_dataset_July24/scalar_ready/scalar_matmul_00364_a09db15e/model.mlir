module {
  func.func @kernel(%arg0: tensor<256x128xf32>, %arg1: tensor<128x192xf32>, %arg2: tensor<256x192xf32>) -> tensor<256x192xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<256x192xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x128xf32>, tensor<128x192xf32>) outs(%arg2 : tensor<256x192xf32>) -> tensor<256x192xf32>
      NAIL.yield %m : tensor<256x192xf32>
    }
    return %r : tensor<256x192xf32>
  }
}
