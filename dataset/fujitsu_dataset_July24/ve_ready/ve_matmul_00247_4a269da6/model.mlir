module {
  func.func @kernel(%arg0: tensor<1728x1856xf16>, %arg1: tensor<1856x2240xf16>, %arg2: tensor<1728x2240xf16>) -> tensor<1728x2240xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1728x2240xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1728x1856xf16>, tensor<1856x2240xf16>) outs(%arg2 : tensor<1728x2240xf16>) -> tensor<1728x2240xf16>
      NAIL.yield %m : tensor<1728x2240xf16>
    }
    return %r : tensor<1728x2240xf16>
  }
}
