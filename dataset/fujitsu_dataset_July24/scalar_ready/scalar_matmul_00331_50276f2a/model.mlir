module {
  func.func @kernel(%arg0: tensor<832x256xf32>, %arg1: tensor<256x3456xf32>, %arg2: tensor<832x3456xf32>) -> tensor<832x3456xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<832x3456xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<832x256xf32>, tensor<256x3456xf32>) outs(%arg2 : tensor<832x3456xf32>) -> tensor<832x3456xf32>
      NAIL.yield %m : tensor<832x3456xf32>
    }
    return %r : tensor<832x3456xf32>
  }
}
