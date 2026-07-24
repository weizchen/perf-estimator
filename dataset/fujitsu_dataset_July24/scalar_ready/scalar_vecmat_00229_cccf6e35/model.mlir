module {
  func.func @kernel(%arg0: tensor<768xf16>, %arg1: tensor<768x1472xf16>, %arg2: tensor<1472xf32>) -> tensor<1472xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1472xf32> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<768xf16>, tensor<768x1472xf16>) outs(%arg2 : tensor<1472xf32>) -> tensor<1472xf32>
      NAIL.yield %z : tensor<1472xf32>
    }
    return %r : tensor<1472xf32>
  }
}
