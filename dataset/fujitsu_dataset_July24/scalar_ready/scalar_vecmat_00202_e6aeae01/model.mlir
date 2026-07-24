module {
  func.func @kernel(%arg0: tensor<1792xi8>, %arg1: tensor<1792x640xi8>, %arg2: tensor<640xi32>) -> tensor<640xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<640xi32> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<1792xi8>, tensor<1792x640xi8>) outs(%arg2 : tensor<640xi32>) -> tensor<640xi32>
      NAIL.yield %z : tensor<640xi32>
    }
    return %r : tensor<640xi32>
  }
}
