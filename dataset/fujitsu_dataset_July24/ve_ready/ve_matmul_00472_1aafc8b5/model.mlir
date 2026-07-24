module {
  func.func @kernel(%arg0: tensor<3968x1728xf32>, %arg1: tensor<1728x2112xf32>, %arg2: tensor<3968x2112xf32>) -> tensor<3968x2112xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3968x2112xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3968x1728xf32>, tensor<1728x2112xf32>) outs(%arg2 : tensor<3968x2112xf32>) -> tensor<3968x2112xf32>
      NAIL.yield %m : tensor<3968x2112xf32>
    }
    return %r : tensor<3968x2112xf32>
  }
}
