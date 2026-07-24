module {
  func.func @kernel(%arg0: tensor<32x768x1792xf16>, %arg1: tensor<32x1792x192xf16>, %arg2: tensor<32x768x192xf32>) -> tensor<32x768x192xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<32x768x192xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<32x768x1792xf16>, tensor<32x1792x192xf16>) outs(%arg2 : tensor<32x768x192xf32>) -> tensor<32x768x192xf32>
      NAIL.yield %z : tensor<32x768x192xf32>
    }
    return %r : tensor<32x768x192xf32>
  }
}
