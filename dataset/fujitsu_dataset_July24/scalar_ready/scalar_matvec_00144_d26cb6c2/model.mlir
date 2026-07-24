module {
  func.func @kernel(%arg0: tensor<1600x256xf16>, %arg1: tensor<256xf16>, %arg2: tensor<1600xf32>) -> tensor<1600xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1600xf32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<1600x256xf16>, tensor<256xf16>) outs(%arg2 : tensor<1600xf32>) -> tensor<1600xf32>
      NAIL.yield %z : tensor<1600xf32>
    }
    return %r : tensor<1600xf32>
  }
}
