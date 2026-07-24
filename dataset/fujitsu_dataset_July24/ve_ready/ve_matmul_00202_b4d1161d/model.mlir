module {
  func.func @kernel(%arg0: tensor<3648x384xf16>, %arg1: tensor<384x2880xf16>, %arg2: tensor<3648x2880xf16>) -> tensor<3648x2880xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3648x2880xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3648x384xf16>, tensor<384x2880xf16>) outs(%arg2 : tensor<3648x2880xf16>) -> tensor<3648x2880xf16>
      NAIL.yield %m : tensor<3648x2880xf16>
    }
    return %r : tensor<3648x2880xf16>
  }
}
