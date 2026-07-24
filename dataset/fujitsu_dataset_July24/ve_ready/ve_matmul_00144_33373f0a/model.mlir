module {
  func.func @kernel(%arg0: tensor<192x2880xf16>, %arg1: tensor<2880x3456xf16>, %arg2: tensor<192x3456xf32>) -> tensor<192x3456xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<192x3456xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<192x2880xf16>, tensor<2880x3456xf16>) outs(%arg2 : tensor<192x3456xf32>) -> tensor<192x3456xf32>
      NAIL.yield %m : tensor<192x3456xf32>
    }
    return %r : tensor<192x3456xf32>
  }
}
