module {
  func.func @kernel(%arg0: tensor<128xf32>, %arg1: tensor<128x256xf32>, %arg2: tensor<256xf32>) -> tensor<256xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<256xf32> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<128xf32>, tensor<128x256xf32>) outs(%arg2 : tensor<256xf32>) -> tensor<256xf32>
      NAIL.yield %z : tensor<256xf32>
    }
    return %r : tensor<256xf32>
  }
}
