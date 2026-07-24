module {
  func.func @kernel(%arg0: tensor<512x256xbf16>, %arg1: tensor<256x1216xbf16>, %arg2: tensor<512x1216xf32>) -> tensor<512x1216xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<512x1216xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x256xbf16>, tensor<256x1216xbf16>) outs(%arg2 : tensor<512x1216xf32>) -> tensor<512x1216xf32>
      NAIL.yield %m : tensor<512x1216xf32>
    }
    return %r : tensor<512x1216xf32>
  }
}
