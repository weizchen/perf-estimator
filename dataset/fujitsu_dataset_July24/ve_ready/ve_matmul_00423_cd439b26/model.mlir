module {
  func.func @kernel(%arg0: tensor<3840x1216xf32>, %arg1: tensor<1216x256xf32>, %arg2: tensor<3840x256xf32>) -> tensor<3840x256xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3840x256xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3840x1216xf32>, tensor<1216x256xf32>) outs(%arg2 : tensor<3840x256xf32>) -> tensor<3840x256xf32>
      NAIL.yield %m : tensor<3840x256xf32>
    }
    return %r : tensor<3840x256xf32>
  }
}
