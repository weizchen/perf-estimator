module {
  func.func @kernel(%arg0: tensor<2048x256xf32>, %arg1: tensor<256x3008xf32>, %arg2: tensor<2048x3008xf32>) -> tensor<2048x3008xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2048x3008xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2048x256xf32>, tensor<256x3008xf32>) outs(%arg2 : tensor<2048x3008xf32>) -> tensor<2048x3008xf32>
      NAIL.yield %m : tensor<2048x3008xf32>
    }
    return %r : tensor<2048x3008xf32>
  }
}
