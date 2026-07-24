module {
  func.func @kernel(%arg0: tensor<768x832xf32>, %arg1: tensor<832x1472xf32>, %arg2: tensor<768x1472xf32>) -> tensor<768x1472xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<768x1472xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<768x832xf32>, tensor<832x1472xf32>) outs(%arg2 : tensor<768x1472xf32>) -> tensor<768x1472xf32>
      NAIL.yield %m : tensor<768x1472xf32>
    }
    return %r : tensor<768x1472xf32>
  }
}
