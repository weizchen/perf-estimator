module {
  func.func @kernel(%arg0: tensor<64x1920xbf16>, %arg1: tensor<1920x256xbf16>, %arg2: tensor<64x256xf32>) -> tensor<64x256xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<64x256xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x1920xbf16>, tensor<1920x256xbf16>) outs(%arg2 : tensor<64x256xf32>) -> tensor<64x256xf32>
      NAIL.yield %m : tensor<64x256xf32>
    }
    return %r : tensor<64x256xf32>
  }
}
