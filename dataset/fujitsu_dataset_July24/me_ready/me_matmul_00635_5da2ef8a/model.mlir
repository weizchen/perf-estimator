module {
  func.func @kernel(%arg0: tensor<512x1152xf16>, %arg1: tensor<1152x128xf16>, %arg2: tensor<512x128xf16>) -> tensor<512x128xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<512x128xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x1152xf16>, tensor<1152x128xf16>) outs(%arg2 : tensor<512x128xf16>) -> tensor<512x128xf16>
      NAIL.yield %m : tensor<512x128xf16>
    }
    return %r : tensor<512x128xf16>
  }
}
