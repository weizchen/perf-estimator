module {
  func.func @kernel(%arg0: tensor<320x384xbf16>, %arg1: tensor<384x2880xbf16>, %arg2: tensor<320x2880xf32>) -> tensor<320x2880xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<320x2880xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x384xbf16>, tensor<384x2880xbf16>) outs(%arg2 : tensor<320x2880xf32>) -> tensor<320x2880xf32>
      NAIL.yield %m : tensor<320x2880xf32>
    }
    return %r : tensor<320x2880xf32>
  }
}
