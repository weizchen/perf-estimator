module {
  func.func @kernel(%arg0: tensor<2880x960xf16>, %arg1: tensor<960x512xf16>, %arg2: tensor<2880x512xf16>) -> tensor<2880x512xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2880x512xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2880x960xf16>, tensor<960x512xf16>) outs(%arg2 : tensor<2880x512xf16>) -> tensor<2880x512xf16>
      NAIL.yield %m : tensor<2880x512xf16>
    }
    return %r : tensor<2880x512xf16>
  }
}
