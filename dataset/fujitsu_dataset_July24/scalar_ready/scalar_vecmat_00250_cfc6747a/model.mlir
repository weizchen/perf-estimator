module {
  func.func @kernel(%arg0: tensor<64xf16>, %arg1: tensor<64x896xf16>, %arg2: tensor<896xf16>) -> tensor<896xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<896xf16> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<64xf16>, tensor<64x896xf16>) outs(%arg2 : tensor<896xf16>) -> tensor<896xf16>
      NAIL.yield %z : tensor<896xf16>
    }
    return %r : tensor<896xf16>
  }
}
