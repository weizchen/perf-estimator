module {
  func.func @kernel(%arg0: tensor<512x1152xf16>, %arg1: tensor<1152x3328xf16>, %arg2: tensor<512x3328xf32>) -> tensor<512x3328xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<512x3328xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x1152xf16>, tensor<1152x3328xf16>) outs(%arg2 : tensor<512x3328xf32>) -> tensor<512x3328xf32>
      NAIL.yield %m : tensor<512x3328xf32>
    }
    return %r : tensor<512x3328xf32>
  }
}
