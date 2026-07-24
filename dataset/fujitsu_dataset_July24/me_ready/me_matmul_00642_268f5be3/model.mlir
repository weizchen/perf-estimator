module {
  func.func @kernel(%arg0: tensor<1472x2112xf16>, %arg1: tensor<2112x128xf16>, %arg2: tensor<1472x128xf16>) -> tensor<1472x128xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1472x128xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1472x2112xf16>, tensor<2112x128xf16>) outs(%arg2 : tensor<1472x128xf16>) -> tensor<1472x128xf16>
      NAIL.yield %m : tensor<1472x128xf16>
    }
    return %r : tensor<1472x128xf16>
  }
}
