module {
  func.func @kernel(%arg0: tensor<4x512x384xi8>, %arg1: tensor<4x384x256xi8>, %arg2: tensor<4x512x256xi32>) -> tensor<4x512x256xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x512x256xi32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<4x512x384xi8>, tensor<4x384x256xi8>) outs(%arg2 : tensor<4x512x256xi32>) -> tensor<4x512x256xi32>
      NAIL.yield %z : tensor<4x512x256xi32>
    }
    return %r : tensor<4x512x256xi32>
  }
}
