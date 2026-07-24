module {
  func.func @kernel(%arg0: tensor<3968x256xi8>, %arg1: tensor<256x640xi8>, %arg2: tensor<3968x640xi32>) -> tensor<3968x640xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<3968x640xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3968x256xi8>, tensor<256x640xi8>) outs(%arg2 : tensor<3968x640xi32>) -> tensor<3968x640xi32>
      NAIL.yield %m : tensor<3968x640xi32>
    }
    return %r : tensor<3968x640xi32>
  }
}
