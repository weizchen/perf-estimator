module {
  func.func @kernel(%arg0: tensor<192x1024xf32>, %arg1: tensor<1024x3904xf32>, %arg2: tensor<192x3904xf32>) -> tensor<192x3904xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<192x3904xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<192x1024xf32>, tensor<1024x3904xf32>) outs(%arg2 : tensor<192x3904xf32>) -> tensor<192x3904xf32>
      NAIL.yield %m : tensor<192x3904xf32>
    }
    return %r : tensor<192x3904xf32>
  }
}
