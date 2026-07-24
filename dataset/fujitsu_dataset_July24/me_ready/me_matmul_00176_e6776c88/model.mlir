module {
  func.func @kernel(%arg0: tensor<2816x3456xf8E5M2>, %arg1: tensor<3456x2048xf8E5M2>, %arg2: tensor<2816x2048xf32>) -> tensor<2816x2048xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<2816x2048xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2816x3456xf8E5M2>, tensor<3456x2048xf8E5M2>) outs(%arg2 : tensor<2816x2048xf32>) -> tensor<2816x2048xf32>
      NAIL.yield %m : tensor<2816x2048xf32>
    }
    return %r : tensor<2816x2048xf32>
  }
}
