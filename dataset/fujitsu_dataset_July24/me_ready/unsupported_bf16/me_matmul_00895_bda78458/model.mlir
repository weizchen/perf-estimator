module {
  func.func @kernel(%arg0: tensor<384x3584xbf16>, %arg1: tensor<3584x1216xbf16>, %arg2: tensor<384x1216xf32>) -> tensor<384x1216xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<384x1216xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x3584xbf16>, tensor<3584x1216xbf16>) outs(%arg2 : tensor<384x1216xf32>) -> tensor<384x1216xf32>
      NAIL.yield %m : tensor<384x1216xf32>
    }
    return %r : tensor<384x1216xf32>
  }
}
