module {
  func.func @kernel(%arg0: tensor<2432x3712xf32>, %arg1: tensor<3712x1984xf32>, %arg2: tensor<2432x1984xf32>) -> tensor<2432x1984xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2432x1984xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2432x3712xf32>, tensor<3712x1984xf32>) outs(%arg2 : tensor<2432x1984xf32>) -> tensor<2432x1984xf32>
      NAIL.yield %m : tensor<2432x1984xf32>
    }
    return %r : tensor<2432x1984xf32>
  }
}
