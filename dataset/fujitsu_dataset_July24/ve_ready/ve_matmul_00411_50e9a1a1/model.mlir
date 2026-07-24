module {
  func.func @kernel(%arg0: tensor<1792x3776xf32>, %arg1: tensor<3776x2816xf32>, %arg2: tensor<1792x2816xf32>) -> tensor<1792x2816xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1792x2816xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1792x3776xf32>, tensor<3776x2816xf32>) outs(%arg2 : tensor<1792x2816xf32>) -> tensor<1792x2816xf32>
      NAIL.yield %m : tensor<1792x2816xf32>
    }
    return %r : tensor<1792x2816xf32>
  }
}
