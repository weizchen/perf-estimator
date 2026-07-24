module {
  func.func @kernel(%arg0: tensor<128x1408xf32>, %arg1: tensor<1408x3776xf32>, %arg2: tensor<128x3776xf32>) -> tensor<128x3776xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<128x3776xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x1408xf32>, tensor<1408x3776xf32>) outs(%arg2 : tensor<128x3776xf32>) -> tensor<128x3776xf32>
      NAIL.yield %m : tensor<128x3776xf32>
    }
    return %r : tensor<128x3776xf32>
  }
}
