module {
  func.func @kernel(%arg0: tensor<640x2944xf8E5M2>, %arg1: tensor<2944x3328xf8E5M2>, %arg2: tensor<640x3328xf32>) -> tensor<640x3328xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<640x3328xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x2944xf8E5M2>, tensor<2944x3328xf8E5M2>) outs(%arg2 : tensor<640x3328xf32>) -> tensor<640x3328xf32>
      NAIL.yield %m : tensor<640x3328xf32>
    }
    return %r : tensor<640x3328xf32>
  }
}
