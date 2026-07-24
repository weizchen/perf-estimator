module {
  func.func @kernel(%arg0: tensor<2x256x1792xi8>, %arg1: tensor<2x1792x512xi8>, %arg2: tensor<2x256x512xi32>) -> tensor<2x256x512xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x256x512xi32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x256x1792xi8>, tensor<2x1792x512xi8>) outs(%arg2 : tensor<2x256x512xi32>) -> tensor<2x256x512xi32>
      NAIL.yield %z : tensor<2x256x512xi32>
    }
    return %r : tensor<2x256x512xi32>
  }
}
