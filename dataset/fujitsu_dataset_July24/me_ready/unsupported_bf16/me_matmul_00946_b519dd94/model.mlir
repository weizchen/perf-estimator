module {
  func.func @kernel(%arg0: tensor<192x1792xbf16>, %arg1: tensor<1792x2944xbf16>, %arg2: tensor<192x2944xf32>) -> tensor<192x2944xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<192x2944xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<192x1792xbf16>, tensor<1792x2944xbf16>) outs(%arg2 : tensor<192x2944xf32>) -> tensor<192x2944xf32>
      NAIL.yield %m : tensor<192x2944xf32>
    }
    return %r : tensor<192x2944xf32>
  }
}
