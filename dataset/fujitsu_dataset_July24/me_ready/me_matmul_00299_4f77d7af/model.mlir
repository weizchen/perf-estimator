module {
  func.func @kernel(%arg0: tensor<192x64xf16>, %arg1: tensor<64x1856xf16>, %arg2: tensor<192x1856xf32>) -> tensor<192x1856xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<192x1856xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<192x64xf16>, tensor<64x1856xf16>) outs(%arg2 : tensor<192x1856xf32>) -> tensor<192x1856xf32>
      NAIL.yield %m : tensor<192x1856xf32>
    }
    return %r : tensor<192x1856xf32>
  }
}
