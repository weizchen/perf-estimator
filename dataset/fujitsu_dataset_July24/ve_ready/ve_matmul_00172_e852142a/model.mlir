module {
  func.func @kernel(%arg0: tensor<2048x320xf16>, %arg1: tensor<320x1408xf16>, %arg2: tensor<2048x1408xf32>) -> tensor<2048x1408xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2048x1408xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2048x320xf16>, tensor<320x1408xf16>) outs(%arg2 : tensor<2048x1408xf32>) -> tensor<2048x1408xf32>
      NAIL.yield %m : tensor<2048x1408xf32>
    }
    return %r : tensor<2048x1408xf32>
  }
}
