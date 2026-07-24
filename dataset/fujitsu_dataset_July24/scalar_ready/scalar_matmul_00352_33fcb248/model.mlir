module {
  func.func @kernel(%arg0: tensor<1024x832xf32>, %arg1: tensor<832x1216xf32>, %arg2: tensor<1024x1216xf32>) -> tensor<1024x1216xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1024x1216xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1024x832xf32>, tensor<832x1216xf32>) outs(%arg2 : tensor<1024x1216xf32>) -> tensor<1024x1216xf32>
      NAIL.yield %m : tensor<1024x1216xf32>
    }
    return %r : tensor<1024x1216xf32>
  }
}
