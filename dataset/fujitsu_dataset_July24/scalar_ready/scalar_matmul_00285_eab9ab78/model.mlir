module {
  func.func @kernel(%arg0: tensor<128x1024xf16>, %arg1: tensor<1024x960xf16>, %arg2: tensor<128x960xf16>) -> tensor<128x960xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<128x960xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x1024xf16>, tensor<1024x960xf16>) outs(%arg2 : tensor<128x960xf16>) -> tensor<128x960xf16>
      NAIL.yield %m : tensor<128x960xf16>
    }
    return %r : tensor<128x960xf16>
  }
}
