module {
  func.func @kernel(%arg0: tensor<32x320x1536xf32>, %arg1: tensor<32x1536x256xf32>, %arg2: tensor<32x320x256xf32>) -> tensor<32x320x256xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<32x320x256xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<32x320x1536xf32>, tensor<32x1536x256xf32>) outs(%arg2 : tensor<32x320x256xf32>) -> tensor<32x320x256xf32>
      NAIL.yield %z : tensor<32x320x256xf32>
    }
    return %r : tensor<32x320x256xf32>
  }
}
