module {
  func.func @kernel(%arg0: tensor<1344x192xf16>, %arg1: tensor<192x512xf16>, %arg2: tensor<1344x512xf32>) -> tensor<1344x512xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1344x512xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1344x192xf16>, tensor<192x512xf16>) outs(%arg2 : tensor<1344x512xf32>) -> tensor<1344x512xf32>
      NAIL.yield %m : tensor<1344x512xf32>
    }
    return %r : tensor<1344x512xf32>
  }
}
