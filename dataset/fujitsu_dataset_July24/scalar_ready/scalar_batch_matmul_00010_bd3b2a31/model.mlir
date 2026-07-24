module {
  func.func @kernel(%arg0: tensor<2x1920x1536xi8>, %arg1: tensor<2x1536x256xi8>, %arg2: tensor<2x1920x256xi32>) -> tensor<2x1920x256xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x1920x256xi32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x1920x1536xi8>, tensor<2x1536x256xi8>) outs(%arg2 : tensor<2x1920x256xi32>) -> tensor<2x1920x256xi32>
      NAIL.yield %z : tensor<2x1920x256xi32>
    }
    return %r : tensor<2x1920x256xi32>
  }
}
