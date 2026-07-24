module {
  func.func @kernel(%arg0: tensor<576x256xbf16>, %arg1: tensor<256x1152xbf16>, %arg2: tensor<576x1152xf32>) -> tensor<576x1152xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<576x1152xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<576x256xbf16>, tensor<256x1152xbf16>) outs(%arg2 : tensor<576x1152xf32>) -> tensor<576x1152xf32>
      NAIL.yield %m : tensor<576x1152xf32>
    }
    return %r : tensor<576x1152xf32>
  }
}
