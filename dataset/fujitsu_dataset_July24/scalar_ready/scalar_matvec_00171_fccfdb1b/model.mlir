module {
  func.func @kernel(%arg0: tensor<448x1536xf16>, %arg1: tensor<1536xf16>, %arg2: tensor<448xf16>) -> tensor<448xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<448xf16> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<448x1536xf16>, tensor<1536xf16>) outs(%arg2 : tensor<448xf16>) -> tensor<448xf16>
      NAIL.yield %z : tensor<448xf16>
    }
    return %r : tensor<448xf16>
  }
}
