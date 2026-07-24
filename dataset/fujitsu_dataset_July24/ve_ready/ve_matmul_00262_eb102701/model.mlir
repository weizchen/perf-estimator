module {
  func.func @kernel(%arg0: tensor<448x2880xf16>, %arg1: tensor<2880x3008xf16>, %arg2: tensor<448x3008xf16>) -> tensor<448x3008xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<448x3008xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<448x2880xf16>, tensor<2880x3008xf16>) outs(%arg2 : tensor<448x3008xf16>) -> tensor<448x3008xf16>
      NAIL.yield %m : tensor<448x3008xf16>
    }
    return %r : tensor<448x3008xf16>
  }
}
