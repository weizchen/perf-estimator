module {
  func.func @kernel(%arg0: tensor<256x2432xi8>, %arg1: tensor<2432x1792xi8>, %arg2: tensor<256x1792xi32>) -> tensor<256x1792xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<256x1792xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x2432xi8>, tensor<2432x1792xi8>) outs(%arg2 : tensor<256x1792xi32>) -> tensor<256x1792xi32>
      NAIL.yield %m : tensor<256x1792xi32>
    }
    return %r : tensor<256x1792xi32>
  }
}
