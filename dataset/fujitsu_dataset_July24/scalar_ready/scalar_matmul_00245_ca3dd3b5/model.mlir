module {
  func.func @kernel(%arg0: tensor<128x1664xf16>, %arg1: tensor<1664x320xf16>, %arg2: tensor<128x320xf16>) -> tensor<128x320xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<128x320xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x1664xf16>, tensor<1664x320xf16>) outs(%arg2 : tensor<128x320xf16>) -> tensor<128x320xf16>
      NAIL.yield %m : tensor<128x320xf16>
    }
    return %r : tensor<128x320xf16>
  }
}
