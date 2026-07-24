module {
  func.func @kernel(%arg0: tensor<3584x960xbf16>, %arg1: tensor<960x1664xbf16>, %arg2: tensor<3584x1664xf32>) -> tensor<3584x1664xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3584x1664xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3584x960xbf16>, tensor<960x1664xbf16>) outs(%arg2 : tensor<3584x1664xf32>) -> tensor<3584x1664xf32>
      NAIL.yield %m : tensor<3584x1664xf32>
    }
    return %r : tensor<3584x1664xf32>
  }
}
