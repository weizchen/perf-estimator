module {
  func.func @kernel(%arg0: tensor<256xf16>, %arg1: tensor<256x256xf16>, %arg2: tensor<256xf16>) -> tensor<256xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<256xf16> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<256xf16>, tensor<256x256xf16>) outs(%arg2 : tensor<256xf16>) -> tensor<256xf16>
      NAIL.yield %z : tensor<256xf16>
    }
    return %r : tensor<256xf16>
  }
}
