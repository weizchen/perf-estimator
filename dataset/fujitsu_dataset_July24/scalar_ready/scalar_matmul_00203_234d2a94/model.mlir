module {
  func.func @kernel(%arg0: tensor<384x1280xf16>, %arg1: tensor<1280x448xf16>, %arg2: tensor<384x448xf32>) -> tensor<384x448xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<384x448xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x1280xf16>, tensor<1280x448xf16>) outs(%arg2 : tensor<384x448xf32>) -> tensor<384x448xf32>
      NAIL.yield %m : tensor<384x448xf32>
    }
    return %r : tensor<384x448xf32>
  }
}
