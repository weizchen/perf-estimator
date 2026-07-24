module {
  func.func @kernel(%arg0: tensor<2176x1664xf32>, %arg1: tensor<1664x832xf32>, %arg2: tensor<2176x832xf32>) -> tensor<2176x832xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2176x832xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2176x1664xf32>, tensor<1664x832xf32>) outs(%arg2 : tensor<2176x832xf32>) -> tensor<2176x832xf32>
      NAIL.yield %m : tensor<2176x832xf32>
    }
    return %r : tensor<2176x832xf32>
  }
}
