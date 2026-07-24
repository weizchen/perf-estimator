module {
  func.func @kernel(%arg0: tensor<576x1856xf32>, %arg1: tensor<1856x256xf32>, %arg2: tensor<576x256xf32>) -> tensor<576x256xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<576x256xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<576x1856xf32>, tensor<1856x256xf32>) outs(%arg2 : tensor<576x256xf32>) -> tensor<576x256xf32>
      NAIL.yield %m : tensor<576x256xf32>
    }
    return %r : tensor<576x256xf32>
  }
}
