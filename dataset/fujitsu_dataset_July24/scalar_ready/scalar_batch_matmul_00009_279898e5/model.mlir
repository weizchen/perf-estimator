module {
  func.func @kernel(%arg0: tensor<32x768x256xi8>, %arg1: tensor<32x256x1920xi8>, %arg2: tensor<32x768x1920xi32>) -> tensor<32x768x1920xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<32x768x1920xi32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<32x768x256xi8>, tensor<32x256x1920xi8>) outs(%arg2 : tensor<32x768x1920xi32>) -> tensor<32x768x1920xi32>
      NAIL.yield %z : tensor<32x768x1920xi32>
    }
    return %r : tensor<32x768x1920xi32>
  }
}
