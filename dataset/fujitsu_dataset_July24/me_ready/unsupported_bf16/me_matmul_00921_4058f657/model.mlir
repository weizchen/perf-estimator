module {
  func.func @kernel(%arg0: tensor<64x1600xbf16>, %arg1: tensor<1600x128xbf16>, %arg2: tensor<64x128xf32>) -> tensor<64x128xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<64x128xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x1600xbf16>, tensor<1600x128xbf16>) outs(%arg2 : tensor<64x128xf32>) -> tensor<64x128xf32>
      NAIL.yield %m : tensor<64x128xf32>
    }
    return %r : tensor<64x128xf32>
  }
}
