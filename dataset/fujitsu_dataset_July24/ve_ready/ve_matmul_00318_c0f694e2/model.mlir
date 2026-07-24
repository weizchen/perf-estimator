module {
  func.func @kernel(%arg0: tensor<64x320xbf16>, %arg1: tensor<320x1024xbf16>, %arg2: tensor<64x1024xf32>) -> tensor<64x1024xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<64x1024xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x320xbf16>, tensor<320x1024xbf16>) outs(%arg2 : tensor<64x1024xf32>) -> tensor<64x1024xf32>
      NAIL.yield %m : tensor<64x1024xf32>
    }
    return %r : tensor<64x1024xf32>
  }
}
