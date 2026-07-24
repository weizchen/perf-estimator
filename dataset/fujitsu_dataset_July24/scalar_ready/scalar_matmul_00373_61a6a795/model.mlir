module {
  func.func @kernel(%arg0: tensor<2112x512xf32>, %arg1: tensor<512x448xf32>, %arg2: tensor<2112x448xf32>) -> tensor<2112x448xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2112x448xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2112x512xf32>, tensor<512x448xf32>) outs(%arg2 : tensor<2112x448xf32>) -> tensor<2112x448xf32>
      NAIL.yield %m : tensor<2112x448xf32>
    }
    return %r : tensor<2112x448xf32>
  }
}
