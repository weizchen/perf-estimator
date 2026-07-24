module {
  func.func @kernel(%arg0: tensor<640x2688xf32>, %arg1: tensor<2688x640xf32>, %arg2: tensor<640x640xf32>) -> tensor<640x640xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<640x640xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x2688xf32>, tensor<2688x640xf32>) outs(%arg2 : tensor<640x640xf32>) -> tensor<640x640xf32>
      NAIL.yield %m : tensor<640x640xf32>
    }
    return %r : tensor<640x640xf32>
  }
}
