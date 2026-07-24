module {
  func.func @kernel(%arg0: tensor<1664x128xf32>, %arg1: tensor<128x960xf32>, %arg2: tensor<1664x960xf32>) -> tensor<1664x960xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1664x960xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1664x128xf32>, tensor<128x960xf32>) outs(%arg2 : tensor<1664x960xf32>) -> tensor<1664x960xf32>
      NAIL.yield %m : tensor<1664x960xf32>
    }
    return %r : tensor<1664x960xf32>
  }
}
