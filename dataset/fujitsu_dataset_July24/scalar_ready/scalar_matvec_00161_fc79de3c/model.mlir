module {
  func.func @kernel(%arg0: tensor<960x256xf16>, %arg1: tensor<256xf16>, %arg2: tensor<960xf16>) -> tensor<960xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<960xf16> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<960x256xf16>, tensor<256xf16>) outs(%arg2 : tensor<960xf16>) -> tensor<960xf16>
      NAIL.yield %z : tensor<960xf16>
    }
    return %r : tensor<960xf16>
  }
}
