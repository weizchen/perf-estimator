module {
  func.func @kernel(%arg0: tensor<2048x576xf16>, %arg1: tensor<576x256xf16>, %arg2: tensor<2048x256xf32>) -> tensor<2048x256xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<2048x256xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2048x576xf16>, tensor<576x256xf16>) outs(%arg2 : tensor<2048x256xf32>) -> tensor<2048x256xf32>
      NAIL.yield %m : tensor<2048x256xf32>
    }
    return %r : tensor<2048x256xf32>
  }
}
