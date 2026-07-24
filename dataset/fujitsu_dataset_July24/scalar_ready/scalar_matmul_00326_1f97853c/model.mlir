module {
  func.func @kernel(%arg0: tensor<832x896xf32>, %arg1: tensor<896x1792xf32>, %arg2: tensor<832x1792xf32>) -> tensor<832x1792xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<832x1792xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<832x896xf32>, tensor<896x1792xf32>) outs(%arg2 : tensor<832x1792xf32>) -> tensor<832x1792xf32>
      NAIL.yield %m : tensor<832x1792xf32>
    }
    return %r : tensor<832x1792xf32>
  }
}
