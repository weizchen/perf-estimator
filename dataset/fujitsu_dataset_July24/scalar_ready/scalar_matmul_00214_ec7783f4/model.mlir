module {
  func.func @kernel(%arg0: tensor<1088x256xf16>, %arg1: tensor<256x128xf16>, %arg2: tensor<1088x128xf16>) -> tensor<1088x128xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1088x128xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1088x256xf16>, tensor<256x128xf16>) outs(%arg2 : tensor<1088x128xf16>) -> tensor<1088x128xf16>
      NAIL.yield %m : tensor<1088x128xf16>
    }
    return %r : tensor<1088x128xf16>
  }
}
