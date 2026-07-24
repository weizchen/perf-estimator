module {
  func.func @kernel(%arg0: tensor<640x128xf16>, %arg1: tensor<128x512xf16>, %arg2: tensor<640x512xf16>) -> tensor<640x512xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<640x512xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x128xf16>, tensor<128x512xf16>) outs(%arg2 : tensor<640x512xf16>) -> tensor<640x512xf16>
      NAIL.yield %m : tensor<640x512xf16>
    }
    return %r : tensor<640x512xf16>
  }
}
