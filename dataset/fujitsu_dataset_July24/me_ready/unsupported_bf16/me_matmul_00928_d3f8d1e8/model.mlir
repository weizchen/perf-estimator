module {
  func.func @kernel(%arg0: tensor<1344x4032xbf16>, %arg1: tensor<4032x2688xbf16>, %arg2: tensor<1344x2688xf32>) -> tensor<1344x2688xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1344x2688xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1344x4032xbf16>, tensor<4032x2688xbf16>) outs(%arg2 : tensor<1344x2688xf32>) -> tensor<1344x2688xf32>
      NAIL.yield %m : tensor<1344x2688xf32>
    }
    return %r : tensor<1344x2688xf32>
  }
}
