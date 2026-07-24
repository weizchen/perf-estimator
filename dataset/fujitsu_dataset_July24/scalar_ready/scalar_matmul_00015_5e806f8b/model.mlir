module {
  func.func @kernel(%arg0: tensor<256x1792xi8>, %arg1: tensor<1792x1536xi8>, %arg2: tensor<256x1536xi32>) -> tensor<256x1536xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<256x1536xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x1792xi8>, tensor<1792x1536xi8>) outs(%arg2 : tensor<256x1536xi32>) -> tensor<256x1536xi32>
      NAIL.yield %m : tensor<256x1536xi32>
    }
    return %r : tensor<256x1536xi32>
  }
}
