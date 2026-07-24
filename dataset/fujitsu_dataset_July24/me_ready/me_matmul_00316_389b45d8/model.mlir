module {
  func.func @kernel(%arg0: tensor<576x256xf16>, %arg1: tensor<256x3776xf16>, %arg2: tensor<576x3776xf32>) -> tensor<576x3776xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<576x3776xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<576x256xf16>, tensor<256x3776xf16>) outs(%arg2 : tensor<576x3776xf32>) -> tensor<576x3776xf32>
      NAIL.yield %m : tensor<576x3776xf32>
    }
    return %r : tensor<576x3776xf32>
  }
}
