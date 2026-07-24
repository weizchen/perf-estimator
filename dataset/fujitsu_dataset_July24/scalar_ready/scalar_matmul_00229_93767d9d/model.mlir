module {
  func.func @kernel(%arg0: tensor<320x384xf16>, %arg1: tensor<384x3648xf16>, %arg2: tensor<320x3648xf16>) -> tensor<320x3648xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<320x3648xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x384xf16>, tensor<384x3648xf16>) outs(%arg2 : tensor<320x3648xf16>) -> tensor<320x3648xf16>
      NAIL.yield %m : tensor<320x3648xf16>
    }
    return %r : tensor<320x3648xf16>
  }
}
