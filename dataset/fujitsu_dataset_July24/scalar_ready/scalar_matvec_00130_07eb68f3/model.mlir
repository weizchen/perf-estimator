module {
  func.func @kernel(%arg0: tensor<384x512xf16>, %arg1: tensor<512xf16>, %arg2: tensor<384xf32>) -> tensor<384xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<384xf32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<384x512xf16>, tensor<512xf16>) outs(%arg2 : tensor<384xf32>) -> tensor<384xf32>
      NAIL.yield %z : tensor<384xf32>
    }
    return %r : tensor<384xf32>
  }
}
