module {
  func.func @kernel(%arg0: tensor<16x704x192xf16>, %arg1: tensor<16x192x320xf16>, %arg2: tensor<16x704x320xf32>) -> tensor<16x704x320xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<16x704x320xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<16x704x192xf16>, tensor<16x192x320xf16>) outs(%arg2 : tensor<16x704x320xf32>) -> tensor<16x704x320xf32>
      NAIL.yield %z : tensor<16x704x320xf32>
    }
    return %r : tensor<16x704x320xf32>
  }
}
