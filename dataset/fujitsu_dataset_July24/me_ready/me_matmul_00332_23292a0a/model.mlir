module {
  func.func @kernel(%arg0: tensor<1728x768xf16>, %arg1: tensor<768x1472xf16>, %arg2: tensor<1728x1472xf32>) -> tensor<1728x1472xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1728x1472xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1728x768xf16>, tensor<768x1472xf16>) outs(%arg2 : tensor<1728x1472xf32>) -> tensor<1728x1472xf32>
      NAIL.yield %m : tensor<1728x1472xf32>
    }
    return %r : tensor<1728x1472xf32>
  }
}
