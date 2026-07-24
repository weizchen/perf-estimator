module {
  func.func @kernel(%arg0: tensor<16x256x384xi8>, %arg1: tensor<16x384x896xi8>, %arg2: tensor<16x256x896xi32>) -> tensor<16x256x896xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<16x256x896xi32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<16x256x384xi8>, tensor<16x384x896xi8>) outs(%arg2 : tensor<16x256x896xi32>) -> tensor<16x256x896xi32>
      NAIL.yield %z : tensor<16x256x896xi32>
    }
    return %r : tensor<16x256x896xi32>
  }
}
