module {
  func.func @kernel(%arg0: tensor<832xf32>, %arg1: tensor<832x64xf32>, %arg2: tensor<64xf32>) -> tensor<64xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<64xf32> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<832xf32>, tensor<832x64xf32>) outs(%arg2 : tensor<64xf32>) -> tensor<64xf32>
      NAIL.yield %z : tensor<64xf32>
    }
    return %r : tensor<64xf32>
  }
}
