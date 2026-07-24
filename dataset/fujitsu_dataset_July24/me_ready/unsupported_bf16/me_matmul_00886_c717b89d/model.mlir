module {
  func.func @kernel(%arg0: tensor<448x1408xbf16>, %arg1: tensor<1408x1408xbf16>, %arg2: tensor<448x1408xf32>) -> tensor<448x1408xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<448x1408xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<448x1408xbf16>, tensor<1408x1408xbf16>) outs(%arg2 : tensor<448x1408xf32>) -> tensor<448x1408xf32>
      NAIL.yield %m : tensor<448x1408xf32>
    }
    return %r : tensor<448x1408xf32>
  }
}
