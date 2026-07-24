module {
  func.func @kernel(%arg0: tensor<704x128xf16>, %arg1: tensor<128x1280xf16>, %arg2: tensor<704x1280xf16>) -> tensor<704x1280xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<704x1280xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<704x128xf16>, tensor<128x1280xf16>) outs(%arg2 : tensor<704x1280xf16>) -> tensor<704x1280xf16>
      NAIL.yield %m : tensor<704x1280xf16>
    }
    return %r : tensor<704x1280xf16>
  }
}
