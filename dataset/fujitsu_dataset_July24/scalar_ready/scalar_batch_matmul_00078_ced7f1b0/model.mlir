module {
  func.func @kernel(%arg0: tensor<8x384x1280xf32>, %arg1: tensor<8x1280x1344xf32>, %arg2: tensor<8x384x1344xf32>) -> tensor<8x384x1344xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<8x384x1344xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<8x384x1280xf32>, tensor<8x1280x1344xf32>) outs(%arg2 : tensor<8x384x1344xf32>) -> tensor<8x384x1344xf32>
      NAIL.yield %z : tensor<8x384x1344xf32>
    }
    return %r : tensor<8x384x1344xf32>
  }
}
