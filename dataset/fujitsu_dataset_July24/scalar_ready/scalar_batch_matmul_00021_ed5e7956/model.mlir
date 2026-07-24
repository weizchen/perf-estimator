module {
  func.func @kernel(%arg0: tensor<8x128x1024xi8>, %arg1: tensor<8x1024x1152xi8>, %arg2: tensor<8x128x1152xi32>) -> tensor<8x128x1152xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<8x128x1152xi32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<8x128x1024xi8>, tensor<8x1024x1152xi8>) outs(%arg2 : tensor<8x128x1152xi32>) -> tensor<8x128x1152xi32>
      NAIL.yield %z : tensor<8x128x1152xi32>
    }
    return %r : tensor<8x128x1152xi32>
  }
}
