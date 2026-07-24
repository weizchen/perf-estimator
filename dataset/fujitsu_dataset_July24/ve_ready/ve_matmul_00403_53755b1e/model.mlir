module {
  func.func @kernel(%arg0: tensor<3008x2112xf32>, %arg1: tensor<2112x128xf32>, %arg2: tensor<3008x128xf32>) -> tensor<3008x128xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3008x128xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3008x2112xf32>, tensor<2112x128xf32>) outs(%arg2 : tensor<3008x128xf32>) -> tensor<3008x128xf32>
      NAIL.yield %m : tensor<3008x128xf32>
    }
    return %r : tensor<3008x128xf32>
  }
}
