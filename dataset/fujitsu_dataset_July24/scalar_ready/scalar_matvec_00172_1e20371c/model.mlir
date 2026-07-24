module {
  func.func @kernel(%arg0: tensor<512x1216xf16>, %arg1: tensor<1216xf16>, %arg2: tensor<512xf16>) -> tensor<512xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<512xf16> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<512x1216xf16>, tensor<1216xf16>) outs(%arg2 : tensor<512xf16>) -> tensor<512xf16>
      NAIL.yield %z : tensor<512xf16>
    }
    return %r : tensor<512xf16>
  }
}
