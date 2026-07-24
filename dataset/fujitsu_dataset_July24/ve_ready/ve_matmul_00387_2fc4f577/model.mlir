module {
  func.func @kernel(%arg0: tensor<256x128xbf16>, %arg1: tensor<128x1600xbf16>, %arg2: tensor<256x1600xf32>) -> tensor<256x1600xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<256x1600xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x128xbf16>, tensor<128x1600xbf16>) outs(%arg2 : tensor<256x1600xf32>) -> tensor<256x1600xf32>
      NAIL.yield %m : tensor<256x1600xf32>
    }
    return %r : tensor<256x1600xf32>
  }
}
