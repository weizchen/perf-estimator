module {
  func.func @kernel(%arg0: tensor<128xf16>, %arg1: tensor<128x64xf16>, %arg2: tensor<64xf16>) -> tensor<64xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<64xf16> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<128xf16>, tensor<128x64xf16>) outs(%arg2 : tensor<64xf16>) -> tensor<64xf16>
      NAIL.yield %z : tensor<64xf16>
    }
    return %r : tensor<64xf16>
  }
}
