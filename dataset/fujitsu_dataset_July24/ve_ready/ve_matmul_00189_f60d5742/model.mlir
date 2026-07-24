module {
  func.func @kernel(%arg0: tensor<320x1152xf16>, %arg1: tensor<1152x768xf16>, %arg2: tensor<320x768xf32>) -> tensor<320x768xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<320x768xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x1152xf16>, tensor<1152x768xf16>) outs(%arg2 : tensor<320x768xf32>) -> tensor<320x768xf32>
      NAIL.yield %m : tensor<320x768xf32>
    }
    return %r : tensor<320x768xf32>
  }
}
