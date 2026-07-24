module {
  func.func @kernel(%arg0: tensor<640xi8>, %arg1: tensor<640x512xi8>, %arg2: tensor<512xi32>) -> tensor<512xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<512xi32> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<640xi8>, tensor<640x512xi8>) outs(%arg2 : tensor<512xi32>) -> tensor<512xi32>
      NAIL.yield %z : tensor<512xi32>
    }
    return %r : tensor<512xi32>
  }
}
