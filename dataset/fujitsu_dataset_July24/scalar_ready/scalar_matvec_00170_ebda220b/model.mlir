module {
  func.func @kernel(%arg0: tensor<384x64xf16>, %arg1: tensor<64xf16>, %arg2: tensor<384xf16>) -> tensor<384xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<384xf16> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<384x64xf16>, tensor<64xf16>) outs(%arg2 : tensor<384xf16>) -> tensor<384xf16>
      NAIL.yield %z : tensor<384xf16>
    }
    return %r : tensor<384xf16>
  }
}
