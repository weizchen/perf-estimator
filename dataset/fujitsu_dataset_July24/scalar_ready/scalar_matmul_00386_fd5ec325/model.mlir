module {
  func.func @kernel(%arg0: tensor<2816x64xf32>, %arg1: tensor<64x1664xf32>, %arg2: tensor<2816x1664xf32>) -> tensor<2816x1664xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2816x1664xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2816x64xf32>, tensor<64x1664xf32>) outs(%arg2 : tensor<2816x1664xf32>) -> tensor<2816x1664xf32>
      NAIL.yield %m : tensor<2816x1664xf32>
    }
    return %r : tensor<2816x1664xf32>
  }
}
