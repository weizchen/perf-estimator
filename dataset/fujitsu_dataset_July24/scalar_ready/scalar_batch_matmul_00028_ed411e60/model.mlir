module {
  func.func @kernel(%arg0: tensor<1x128x512xf16>, %arg1: tensor<1x512x1152xf16>, %arg2: tensor<1x128x1152xf32>) -> tensor<1x128x1152xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x128x1152xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<1x128x512xf16>, tensor<1x512x1152xf16>) outs(%arg2 : tensor<1x128x1152xf32>) -> tensor<1x128x1152xf32>
      NAIL.yield %z : tensor<1x128x1152xf32>
    }
    return %r : tensor<1x128x1152xf32>
  }
}
