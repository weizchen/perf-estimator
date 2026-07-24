module {
  func.func @kernel(%arg0: tensor<384x3328xf16>, %arg1: tensor<3328x1792xf16>, %arg2: tensor<384x1792xf16>) -> tensor<384x1792xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<384x1792xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x3328xf16>, tensor<3328x1792xf16>) outs(%arg2 : tensor<384x1792xf16>) -> tensor<384x1792xf16>
      NAIL.yield %m : tensor<384x1792xf16>
    }
    return %r : tensor<384x1792xf16>
  }
}
