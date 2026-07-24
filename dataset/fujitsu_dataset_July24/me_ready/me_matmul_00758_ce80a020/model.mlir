module {
  func.func @kernel(%arg0: tensor<3648x128xf16>, %arg1: tensor<128x2368xf16>, %arg2: tensor<3648x2368xf16>) -> tensor<3648x2368xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<3648x2368xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3648x128xf16>, tensor<128x2368xf16>) outs(%arg2 : tensor<3648x2368xf16>) -> tensor<3648x2368xf16>
      NAIL.yield %m : tensor<3648x2368xf16>
    }
    return %r : tensor<3648x2368xf16>
  }
}
