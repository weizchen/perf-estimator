module {
  func.func @kernel(%arg0: tensor<384x1152xbf16>, %arg1: tensor<1152x896xbf16>, %arg2: tensor<384x896xf32>) -> tensor<384x896xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<384x896xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x1152xbf16>, tensor<1152x896xbf16>) outs(%arg2 : tensor<384x896xf32>) -> tensor<384x896xf32>
      NAIL.yield %m : tensor<384x896xf32>
    }
    return %r : tensor<384x896xf32>
  }
}
