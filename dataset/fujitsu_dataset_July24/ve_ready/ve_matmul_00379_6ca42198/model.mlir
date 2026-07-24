module {
  func.func @kernel(%arg0: tensor<384x3136xbf16>, %arg1: tensor<3136x320xbf16>, %arg2: tensor<384x320xf32>) -> tensor<384x320xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<384x320xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x3136xbf16>, tensor<3136x320xbf16>) outs(%arg2 : tensor<384x320xf32>) -> tensor<384x320xf32>
      NAIL.yield %m : tensor<384x320xf32>
    }
    return %r : tensor<384x320xf32>
  }
}
