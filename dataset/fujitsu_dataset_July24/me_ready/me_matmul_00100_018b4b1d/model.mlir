module {
  func.func @kernel(%arg0: tensor<2816x3072xf8E5M2>, %arg1: tensor<3072x1152xf8E5M2>, %arg2: tensor<2816x1152xf32>) -> tensor<2816x1152xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<2816x1152xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2816x3072xf8E5M2>, tensor<3072x1152xf8E5M2>) outs(%arg2 : tensor<2816x1152xf32>) -> tensor<2816x1152xf32>
      NAIL.yield %m : tensor<2816x1152xf32>
    }
    return %r : tensor<2816x1152xf32>
  }
}
