module {
  func.func @kernel(%arg0: tensor<384x384xf8E5M2>, %arg1: tensor<384x3456xf8E5M2>, %arg2: tensor<384x3456xf32>) -> tensor<384x3456xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<384x3456xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x384xf8E5M2>, tensor<384x3456xf8E5M2>) outs(%arg2 : tensor<384x3456xf32>) -> tensor<384x3456xf32>
      NAIL.yield %m : tensor<384x3456xf32>
    }
    return %r : tensor<384x3456xf32>
  }
}
