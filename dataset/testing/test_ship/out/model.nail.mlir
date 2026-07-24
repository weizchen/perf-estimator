module {
  func.func @kernel(%arg0: tensor<256x128xf32>, %arg1: tensor<128x256xf32>, %arg2: tensor<256x256xf32>) -> tensor<256x256xf32> {
    %0 = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0,proc : 2> -> tensor<256x256xf32> {
      %1 = linalg.matmul ins(%arg0, %arg1 : tensor<256x128xf32>, tensor<128x256xf32>) outs(%arg2 : tensor<256x256xf32>) -> tensor<256x256xf32>
      NAIL.yield %1 : tensor<256x256xf32>
    }
    return %0 : tensor<256x256xf32>
  }
}
