module {
  func.func @kernel(%arg0: tensor<192x576xf16>, %arg1: tensor<576x1344xf16>, %arg2: tensor<192x1344xf32>) -> tensor<192x1344xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<192x1344xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<192x576xf16>, tensor<576x1344xf16>) outs(%arg2 : tensor<192x1344xf32>) -> tensor<192x1344xf32>
      NAIL.yield %m : tensor<192x1344xf32>
    }
    return %r : tensor<192x1344xf32>
  }
}
