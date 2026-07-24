module {
  func.func @kernel(%arg0: tensor<192xf16>, %arg1: tensor<192x192xf16>, %arg2: tensor<192xf16>) -> tensor<192xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<192xf16> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<192xf16>, tensor<192x192xf16>) outs(%arg2 : tensor<192xf16>) -> tensor<192xf16>
      NAIL.yield %z : tensor<192xf16>
    }
    return %r : tensor<192xf16>
  }
}
