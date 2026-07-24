module {
  func.func @kernel(%arg0: tensor<320x1792xf16>, %arg1: tensor<1792x256xf16>, %arg2: tensor<320x256xf16>) -> tensor<320x256xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<320x256xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x1792xf16>, tensor<1792x256xf16>) outs(%arg2 : tensor<320x256xf16>) -> tensor<320x256xf16>
      NAIL.yield %m : tensor<320x256xf16>
    }
    return %r : tensor<320x256xf16>
  }
}
