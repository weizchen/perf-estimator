module {
  func.func @kernel(%arg0: tensor<768x1216xf16>, %arg1: tensor<1216x576xf16>, %arg2: tensor<768x576xf16>) -> tensor<768x576xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<768x576xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<768x1216xf16>, tensor<1216x576xf16>) outs(%arg2 : tensor<768x576xf16>) -> tensor<768x576xf16>
      NAIL.yield %m : tensor<768x576xf16>
    }
    return %r : tensor<768x576xf16>
  }
}
