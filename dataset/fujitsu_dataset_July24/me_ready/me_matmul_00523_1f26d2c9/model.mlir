module {
  func.func @kernel(%arg0: tensor<448x256xf16>, %arg1: tensor<256x384xf16>, %arg2: tensor<448x384xf32>) -> tensor<448x384xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<448x384xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<448x256xf16>, tensor<256x384xf16>) outs(%arg2 : tensor<448x384xf32>) -> tensor<448x384xf32>
      NAIL.yield %m : tensor<448x384xf32>
    }
    return %r : tensor<448x384xf32>
  }
}
