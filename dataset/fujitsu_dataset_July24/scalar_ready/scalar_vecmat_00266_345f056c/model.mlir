module {
  func.func @kernel(%arg0: tensor<192xf16>, %arg1: tensor<192x576xf16>, %arg2: tensor<576xf16>) -> tensor<576xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<576xf16> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<192xf16>, tensor<192x576xf16>) outs(%arg2 : tensor<576xf16>) -> tensor<576xf16>
      NAIL.yield %z : tensor<576xf16>
    }
    return %r : tensor<576xf16>
  }
}
