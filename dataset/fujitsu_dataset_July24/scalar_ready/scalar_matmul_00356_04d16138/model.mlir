module {
  func.func @kernel(%arg0: tensor<320x640xf32>, %arg1: tensor<640x1408xf32>, %arg2: tensor<320x1408xf32>) -> tensor<320x1408xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<320x1408xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x640xf32>, tensor<640x1408xf32>) outs(%arg2 : tensor<320x1408xf32>) -> tensor<320x1408xf32>
      NAIL.yield %m : tensor<320x1408xf32>
    }
    return %r : tensor<320x1408xf32>
  }
}
