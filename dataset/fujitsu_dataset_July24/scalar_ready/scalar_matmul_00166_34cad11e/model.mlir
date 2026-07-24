module {
  func.func @kernel(%arg0: tensor<768x768xf16>, %arg1: tensor<768x576xf16>, %arg2: tensor<768x576xf32>) -> tensor<768x576xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<768x576xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<768x768xf16>, tensor<768x576xf16>) outs(%arg2 : tensor<768x576xf32>) -> tensor<768x576xf32>
      NAIL.yield %m : tensor<768x576xf32>
    }
    return %r : tensor<768x576xf32>
  }
}
