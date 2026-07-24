module {
  func.func @kernel(%arg0: tensor<1216x64xf16>, %arg1: tensor<64x256xf16>, %arg2: tensor<1216x256xf16>) -> tensor<1216x256xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1216x256xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1216x64xf16>, tensor<64x256xf16>) outs(%arg2 : tensor<1216x256xf16>) -> tensor<1216x256xf16>
      NAIL.yield %m : tensor<1216x256xf16>
    }
    return %r : tensor<1216x256xf16>
  }
}
