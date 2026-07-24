module {
  func.func @kernel(%arg0: tensor<1344xf16>, %arg1: tensor<1344x768xf16>, %arg2: tensor<768xf16>) -> tensor<768xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<768xf16> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<1344xf16>, tensor<1344x768xf16>) outs(%arg2 : tensor<768xf16>) -> tensor<768xf16>
      NAIL.yield %z : tensor<768xf16>
    }
    return %r : tensor<768xf16>
  }
}
