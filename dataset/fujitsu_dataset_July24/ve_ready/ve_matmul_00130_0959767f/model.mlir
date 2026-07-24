module {
  func.func @kernel(%arg0: tensor<448x192xf16>, %arg1: tensor<192x384xf16>, %arg2: tensor<448x384xf32>) -> tensor<448x384xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<448x384xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<448x192xf16>, tensor<192x384xf16>) outs(%arg2 : tensor<448x384xf32>) -> tensor<448x384xf32>
      NAIL.yield %m : tensor<448x384xf32>
    }
    return %r : tensor<448x384xf32>
  }
}
