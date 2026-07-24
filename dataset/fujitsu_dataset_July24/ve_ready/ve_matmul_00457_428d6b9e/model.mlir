module {
  func.func @kernel(%arg0: tensor<512x2240xf32>, %arg1: tensor<2240x3584xf32>, %arg2: tensor<512x3584xf32>) -> tensor<512x3584xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<512x3584xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x2240xf32>, tensor<2240x3584xf32>) outs(%arg2 : tensor<512x3584xf32>) -> tensor<512x3584xf32>
      NAIL.yield %m : tensor<512x3584xf32>
    }
    return %r : tensor<512x3584xf32>
  }
}
