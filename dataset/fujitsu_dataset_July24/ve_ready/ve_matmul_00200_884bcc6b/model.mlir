module {
  func.func @kernel(%arg0: tensor<384x1536xf16>, %arg1: tensor<1536x1664xf16>, %arg2: tensor<384x1664xf16>) -> tensor<384x1664xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<384x1664xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x1536xf16>, tensor<1536x1664xf16>) outs(%arg2 : tensor<384x1664xf16>) -> tensor<384x1664xf16>
      NAIL.yield %m : tensor<384x1664xf16>
    }
    return %r : tensor<384x1664xf16>
  }
}
