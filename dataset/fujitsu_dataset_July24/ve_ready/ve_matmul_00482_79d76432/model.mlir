module {
  func.func @kernel(%arg0: tensor<704x512xf32>, %arg1: tensor<512x896xf32>, %arg2: tensor<704x896xf32>) -> tensor<704x896xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<704x896xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<704x512xf32>, tensor<512x896xf32>) outs(%arg2 : tensor<704x896xf32>) -> tensor<704x896xf32>
      NAIL.yield %m : tensor<704x896xf32>
    }
    return %r : tensor<704x896xf32>
  }
}
