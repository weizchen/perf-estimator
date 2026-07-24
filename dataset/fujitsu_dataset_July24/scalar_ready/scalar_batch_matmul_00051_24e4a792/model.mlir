module {
  func.func @kernel(%arg0: tensor<16x384x1664xf16>, %arg1: tensor<16x1664x192xf16>, %arg2: tensor<16x384x192xf16>) -> tensor<16x384x192xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<16x384x192xf16> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<16x384x1664xf16>, tensor<16x1664x192xf16>) outs(%arg2 : tensor<16x384x192xf16>) -> tensor<16x384x192xf16>
      NAIL.yield %z : tensor<16x384x192xf16>
    }
    return %r : tensor<16x384x192xf16>
  }
}
