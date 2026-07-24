module {
  func.func @kernel(%arg0: tensor<960x3456xf16>, %arg1: tensor<3456x128xf16>, %arg2: tensor<960x128xf16>) -> tensor<960x128xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<960x128xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<960x3456xf16>, tensor<3456x128xf16>) outs(%arg2 : tensor<960x128xf16>) -> tensor<960x128xf16>
      NAIL.yield %m : tensor<960x128xf16>
    }
    return %r : tensor<960x128xf16>
  }
}
