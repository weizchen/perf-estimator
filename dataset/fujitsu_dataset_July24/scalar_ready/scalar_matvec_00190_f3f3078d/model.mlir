module {
  func.func @kernel(%arg0: tensor<640x896xf32>, %arg1: tensor<896xf32>, %arg2: tensor<640xf32>) -> tensor<640xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<640xf32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<640x896xf32>, tensor<896xf32>) outs(%arg2 : tensor<640xf32>) -> tensor<640xf32>
      NAIL.yield %z : tensor<640xf32>
    }
    return %r : tensor<640xf32>
  }
}
