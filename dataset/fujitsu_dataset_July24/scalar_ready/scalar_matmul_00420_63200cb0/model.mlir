module {
  func.func @kernel(%arg0: tensor<448x960xf32>, %arg1: tensor<960x832xf32>, %arg2: tensor<448x832xf32>) -> tensor<448x832xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<448x832xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<448x960xf32>, tensor<960x832xf32>) outs(%arg2 : tensor<448x832xf32>) -> tensor<448x832xf32>
      NAIL.yield %m : tensor<448x832xf32>
    }
    return %r : tensor<448x832xf32>
  }
}
