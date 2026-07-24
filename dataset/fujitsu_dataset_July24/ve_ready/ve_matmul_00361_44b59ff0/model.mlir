module {
  func.func @kernel(%arg0: tensor<2688x896xbf16>, %arg1: tensor<896x640xbf16>, %arg2: tensor<2688x640xf32>) -> tensor<2688x640xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2688x640xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2688x896xbf16>, tensor<896x640xbf16>) outs(%arg2 : tensor<2688x640xf32>) -> tensor<2688x640xf32>
      NAIL.yield %m : tensor<2688x640xf32>
    }
    return %r : tensor<2688x640xf32>
  }
}
