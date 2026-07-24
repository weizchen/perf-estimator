module {
  func.func @kernel(%arg0: tensor<192x896xf32>, %arg1: tensor<896xf32>, %arg2: tensor<192xf32>) -> tensor<192xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<192xf32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<192x896xf32>, tensor<896xf32>) outs(%arg2 : tensor<192xf32>) -> tensor<192xf32>
      NAIL.yield %z : tensor<192xf32>
    }
    return %r : tensor<192xf32>
  }
}
