module {
  func.func @kernel(%arg0: tensor<128x1728xf16>, %arg1: tensor<1728x2368xf16>, %arg2: tensor<128x2368xf32>) -> tensor<128x2368xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<128x2368xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x1728xf16>, tensor<1728x2368xf16>) outs(%arg2 : tensor<128x2368xf32>) -> tensor<128x2368xf32>
      NAIL.yield %m : tensor<128x2368xf32>
    }
    return %r : tensor<128x2368xf32>
  }
}
