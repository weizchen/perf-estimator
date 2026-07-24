module {
  func.func @kernel(%arg0: tensor<3264x64xf32>, %arg1: tensor<64x320xf32>, %arg2: tensor<3264x320xf32>) -> tensor<3264x320xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3264x320xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3264x64xf32>, tensor<64x320xf32>) outs(%arg2 : tensor<3264x320xf32>) -> tensor<3264x320xf32>
      NAIL.yield %m : tensor<3264x320xf32>
    }
    return %r : tensor<3264x320xf32>
  }
}
