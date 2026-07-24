module {
  func.func @kernel(%arg0: tensor<192x64xf16>, %arg1: tensor<64x448xf16>, %arg2: tensor<192x448xf16>) -> tensor<192x448xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<192x448xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<192x64xf16>, tensor<64x448xf16>) outs(%arg2 : tensor<192x448xf16>) -> tensor<192x448xf16>
      NAIL.yield %m : tensor<192x448xf16>
    }
    return %r : tensor<192x448xf16>
  }
}
