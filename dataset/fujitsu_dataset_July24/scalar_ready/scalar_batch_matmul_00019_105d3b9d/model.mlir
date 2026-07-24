module {
  func.func @kernel(%arg0: tensor<1x1024x1664xi8>, %arg1: tensor<1x1664x1792xi8>, %arg2: tensor<1x1024x1792xi32>) -> tensor<1x1024x1792xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x1024x1792xi32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<1x1024x1664xi8>, tensor<1x1664x1792xi8>) outs(%arg2 : tensor<1x1024x1792xi32>) -> tensor<1x1024x1792xi32>
      NAIL.yield %z : tensor<1x1024x1792xi32>
    }
    return %r : tensor<1x1024x1792xi32>
  }
}
