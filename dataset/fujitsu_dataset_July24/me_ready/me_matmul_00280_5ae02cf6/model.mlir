module {
  func.func @kernel(%arg0: tensor<1216x1920xf16>, %arg1: tensor<1920x1664xf16>, %arg2: tensor<1216x1664xf32>) -> tensor<1216x1664xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1216x1664xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1216x1920xf16>, tensor<1920x1664xf16>) outs(%arg2 : tensor<1216x1664xf32>) -> tensor<1216x1664xf32>
      NAIL.yield %m : tensor<1216x1664xf32>
    }
    return %r : tensor<1216x1664xf32>
  }
}
