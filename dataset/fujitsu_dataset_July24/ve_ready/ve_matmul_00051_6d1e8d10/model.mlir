module {
  func.func @kernel(%arg0: tensor<1536x256xi8>, %arg1: tensor<256x1408xi8>, %arg2: tensor<1536x1408xi32>) -> tensor<1536x1408xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1536x1408xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1536x256xi8>, tensor<256x1408xi8>) outs(%arg2 : tensor<1536x1408xi32>) -> tensor<1536x1408xi32>
      NAIL.yield %m : tensor<1536x1408xi32>
    }
    return %r : tensor<1536x1408xi32>
  }
}
