module {
  func.func @kernel(%arg0: tensor<192x64xf32>, %arg1: tensor<64x512xf32>, %arg2: tensor<192x512xf32>) -> tensor<192x512xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<192x512xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<192x64xf32>, tensor<64x512xf32>) outs(%arg2 : tensor<192x512xf32>) -> tensor<192x512xf32>
      NAIL.yield %m : tensor<192x512xf32>
    }
    return %r : tensor<192x512xf32>
  }
}
