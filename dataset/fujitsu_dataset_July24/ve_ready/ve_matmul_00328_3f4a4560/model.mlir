module {
  func.func @kernel(%arg0: tensor<576x384xbf16>, %arg1: tensor<384x1536xbf16>, %arg2: tensor<576x1536xf32>) -> tensor<576x1536xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<576x1536xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<576x384xbf16>, tensor<384x1536xbf16>) outs(%arg2 : tensor<576x1536xf32>) -> tensor<576x1536xf32>
      NAIL.yield %m : tensor<576x1536xf32>
    }
    return %r : tensor<576x1536xf32>
  }
}
