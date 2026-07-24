module {
  func.func @kernel(%arg0: tensor<320x128xbf16>, %arg1: tensor<128x384xbf16>, %arg2: tensor<320x384xf16>) -> tensor<320x384xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<320x384xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x128xbf16>, tensor<128x384xbf16>) outs(%arg2 : tensor<320x384xf16>) -> tensor<320x384xf16>
      NAIL.yield %m : tensor<320x384xf16>
    }
    return %r : tensor<320x384xf16>
  }
}
