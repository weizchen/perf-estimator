module {
  func.func @kernel(%arg0: tensor<2944x3712xf32>, %arg1: tensor<3712x3328xf32>, %arg2: tensor<2944x3328xf32>) -> tensor<2944x3328xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2944x3328xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2944x3712xf32>, tensor<3712x3328xf32>) outs(%arg2 : tensor<2944x3328xf32>) -> tensor<2944x3328xf32>
      NAIL.yield %m : tensor<2944x3328xf32>
    }
    return %r : tensor<2944x3328xf32>
  }
}
