module {
  func.func @kernel(%arg0: tensor<3776x1600xf32>, %arg1: tensor<1600x64xf32>, %arg2: tensor<3776x64xf32>) -> tensor<3776x64xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3776x64xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3776x1600xf32>, tensor<1600x64xf32>) outs(%arg2 : tensor<3776x64xf32>) -> tensor<3776x64xf32>
      NAIL.yield %m : tensor<3776x64xf32>
    }
    return %r : tensor<3776x64xf32>
  }
}
