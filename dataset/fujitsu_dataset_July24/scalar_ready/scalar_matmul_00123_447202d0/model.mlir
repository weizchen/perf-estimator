module {
  func.func @kernel(%arg0: tensor<320x384xf16>, %arg1: tensor<384x2368xf16>, %arg2: tensor<320x2368xf32>) -> tensor<320x2368xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<320x2368xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x384xf16>, tensor<384x2368xf16>) outs(%arg2 : tensor<320x2368xf32>) -> tensor<320x2368xf32>
      NAIL.yield %m : tensor<320x2368xf32>
    }
    return %r : tensor<320x2368xf32>
  }
}
