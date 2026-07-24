module {
  func.func @kernel(%arg0: tensor<32x960x512xf32>, %arg1: tensor<32x512x576xf32>, %arg2: tensor<32x960x576xf32>) -> tensor<32x960x576xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<32x960x576xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<32x960x512xf32>, tensor<32x512x576xf32>) outs(%arg2 : tensor<32x960x576xf32>) -> tensor<32x960x576xf32>
      NAIL.yield %z : tensor<32x960x576xf32>
    }
    return %r : tensor<32x960x576xf32>
  }
}
