module {
  func.func @kernel(%arg0: tensor<512x1920xf32>, %arg1: tensor<1920x4032xf32>, %arg2: tensor<512x4032xf32>) -> tensor<512x4032xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<512x4032xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x1920xf32>, tensor<1920x4032xf32>) outs(%arg2 : tensor<512x4032xf32>) -> tensor<512x4032xf32>
      NAIL.yield %m : tensor<512x4032xf32>
    }
    return %r : tensor<512x4032xf32>
  }
}
