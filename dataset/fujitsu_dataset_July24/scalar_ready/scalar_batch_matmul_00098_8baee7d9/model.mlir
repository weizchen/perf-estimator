module {
  func.func @kernel(%arg0: tensor<16x128x448xf32>, %arg1: tensor<16x448x640xf32>, %arg2: tensor<16x128x640xf32>) -> tensor<16x128x640xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<16x128x640xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<16x128x448xf32>, tensor<16x448x640xf32>) outs(%arg2 : tensor<16x128x640xf32>) -> tensor<16x128x640xf32>
      NAIL.yield %z : tensor<16x128x640xf32>
    }
    return %r : tensor<16x128x640xf32>
  }
}
