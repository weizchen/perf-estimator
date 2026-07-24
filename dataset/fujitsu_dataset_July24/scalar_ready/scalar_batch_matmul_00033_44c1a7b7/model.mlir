module {
  func.func @kernel(%arg0: tensor<8x192x320xf16>, %arg1: tensor<8x320x2048xf16>, %arg2: tensor<8x192x2048xf32>) -> tensor<8x192x2048xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<8x192x2048xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<8x192x320xf16>, tensor<8x320x2048xf16>) outs(%arg2 : tensor<8x192x2048xf32>) -> tensor<8x192x2048xf32>
      NAIL.yield %z : tensor<8x192x2048xf32>
    }
    return %r : tensor<8x192x2048xf32>
  }
}
