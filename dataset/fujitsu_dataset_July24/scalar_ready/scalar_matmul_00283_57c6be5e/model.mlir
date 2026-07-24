module {
  func.func @kernel(%arg0: tensor<832x1536xf16>, %arg1: tensor<1536x1152xf16>, %arg2: tensor<832x1152xf16>) -> tensor<832x1152xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<832x1152xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<832x1536xf16>, tensor<1536x1152xf16>) outs(%arg2 : tensor<832x1152xf16>) -> tensor<832x1152xf16>
      NAIL.yield %m : tensor<832x1152xf16>
    }
    return %r : tensor<832x1152xf16>
  }
}
