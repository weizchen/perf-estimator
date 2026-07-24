module {
  func.func @kernel(%arg0: tensor<512x1920xf8E5M2>, %arg1: tensor<1920x640xf8E5M2>, %arg2: tensor<512x640xf32>) -> tensor<512x640xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<512x640xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x1920xf8E5M2>, tensor<1920x640xf8E5M2>) outs(%arg2 : tensor<512x640xf32>) -> tensor<512x640xf32>
      NAIL.yield %m : tensor<512x640xf32>
    }
    return %r : tensor<512x640xf32>
  }
}
