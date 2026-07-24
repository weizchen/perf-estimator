module {
  func.func @kernel(%arg0: tensor<2x128x256xi8>, %arg1: tensor<2x256x256xi8>, %arg2: tensor<2x128x256xi32>) -> tensor<2x128x256xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x128x256xi32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x128x256xi8>, tensor<2x256x256xi8>) outs(%arg2 : tensor<2x128x256xi32>) -> tensor<2x128x256xi32>
      NAIL.yield %z : tensor<2x128x256xi32>
    }
    return %r : tensor<2x128x256xi32>
  }
}
