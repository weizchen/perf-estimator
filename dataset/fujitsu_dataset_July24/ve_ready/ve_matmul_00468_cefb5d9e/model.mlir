module {
  func.func @kernel(%arg0: tensor<2752x448xf32>, %arg1: tensor<448x2048xf32>, %arg2: tensor<2752x2048xf32>) -> tensor<2752x2048xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2752x2048xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2752x448xf32>, tensor<448x2048xf32>) outs(%arg2 : tensor<2752x2048xf32>) -> tensor<2752x2048xf32>
      NAIL.yield %m : tensor<2752x2048xf32>
    }
    return %r : tensor<2752x2048xf32>
  }
}
