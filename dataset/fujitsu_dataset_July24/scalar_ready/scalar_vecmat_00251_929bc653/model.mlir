module {
  func.func @kernel(%arg0: tensor<640xf16>, %arg1: tensor<640x1792xf16>, %arg2: tensor<1792xf16>) -> tensor<1792xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1792xf16> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<640xf16>, tensor<640x1792xf16>) outs(%arg2 : tensor<1792xf16>) -> tensor<1792xf16>
      NAIL.yield %z : tensor<1792xf16>
    }
    return %r : tensor<1792xf16>
  }
}
