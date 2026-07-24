module {
  func.func @kernel(%arg0: tensor<192x896xf16>, %arg1: tensor<896x128xf16>, %arg2: tensor<192x128xf32>) -> tensor<192x128xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<192x128xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<192x896xf16>, tensor<896x128xf16>) outs(%arg2 : tensor<192x128xf32>) -> tensor<192x128xf32>
      NAIL.yield %m : tensor<192x128xf32>
    }
    return %r : tensor<192x128xf32>
  }
}
