module {
  func.func @kernel(%arg0: tensor<4032x1856xf16>, %arg1: tensor<1856x1088xf16>, %arg2: tensor<4032x1088xf32>) -> tensor<4032x1088xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<4032x1088xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<4032x1856xf16>, tensor<1856x1088xf16>) outs(%arg2 : tensor<4032x1088xf32>) -> tensor<4032x1088xf32>
      NAIL.yield %m : tensor<4032x1088xf32>
    }
    return %r : tensor<4032x1088xf32>
  }
}
