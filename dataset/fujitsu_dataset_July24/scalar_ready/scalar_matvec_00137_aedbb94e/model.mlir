module {
  func.func @kernel(%arg0: tensor<1408x576xf16>, %arg1: tensor<576xf16>, %arg2: tensor<1408xf32>) -> tensor<1408xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1408xf32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<1408x576xf16>, tensor<576xf16>) outs(%arg2 : tensor<1408xf32>) -> tensor<1408xf32>
      NAIL.yield %z : tensor<1408xf32>
    }
    return %r : tensor<1408xf32>
  }
}
