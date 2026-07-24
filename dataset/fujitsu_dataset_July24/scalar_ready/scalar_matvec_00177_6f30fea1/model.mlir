module {
  func.func @kernel(%arg0: tensor<1536x192xf32>, %arg1: tensor<192xf32>, %arg2: tensor<1536xf32>) -> tensor<1536xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1536xf32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<1536x192xf32>, tensor<192xf32>) outs(%arg2 : tensor<1536xf32>) -> tensor<1536xf32>
      NAIL.yield %z : tensor<1536xf32>
    }
    return %r : tensor<1536xf32>
  }
}
