module {
  func.func @kernel(%arg0: tensor<1344x896xbf16>, %arg1: tensor<896x2688xbf16>, %arg2: tensor<1344x2688xf16>) -> tensor<1344x2688xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1344x2688xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1344x896xbf16>, tensor<896x2688xbf16>) outs(%arg2 : tensor<1344x2688xf16>) -> tensor<1344x2688xf16>
      NAIL.yield %m : tensor<1344x2688xf16>
    }
    return %r : tensor<1344x2688xf16>
  }
}
