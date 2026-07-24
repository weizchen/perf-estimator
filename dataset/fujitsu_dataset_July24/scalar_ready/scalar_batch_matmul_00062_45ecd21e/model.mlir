module {
  func.func @kernel(%arg0: tensor<16x192x448xf16>, %arg1: tensor<16x448x1792xf16>, %arg2: tensor<16x192x1792xf16>) -> tensor<16x192x1792xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<16x192x1792xf16> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<16x192x448xf16>, tensor<16x448x1792xf16>) outs(%arg2 : tensor<16x192x1792xf16>) -> tensor<16x192x1792xf16>
      NAIL.yield %z : tensor<16x192x1792xf16>
    }
    return %r : tensor<16x192x1792xf16>
  }
}
