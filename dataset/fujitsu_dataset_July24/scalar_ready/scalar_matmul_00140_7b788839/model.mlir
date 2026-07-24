module {
  func.func @kernel(%arg0: tensor<1728x192xf16>, %arg1: tensor<192x1856xf16>, %arg2: tensor<1728x1856xf32>) -> tensor<1728x1856xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1728x1856xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1728x192xf16>, tensor<192x1856xf16>) outs(%arg2 : tensor<1728x1856xf32>) -> tensor<1728x1856xf32>
      NAIL.yield %m : tensor<1728x1856xf32>
    }
    return %r : tensor<1728x1856xf32>
  }
}
