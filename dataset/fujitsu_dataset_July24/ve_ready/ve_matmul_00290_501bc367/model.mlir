module {
  func.func @kernel(%arg0: tensor<640x1920xf16>, %arg1: tensor<1920x3392xf16>, %arg2: tensor<640x3392xf16>) -> tensor<640x3392xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<640x3392xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x1920xf16>, tensor<1920x3392xf16>) outs(%arg2 : tensor<640x3392xf16>) -> tensor<640x3392xf16>
      NAIL.yield %m : tensor<640x3392xf16>
    }
    return %r : tensor<640x3392xf16>
  }
}
