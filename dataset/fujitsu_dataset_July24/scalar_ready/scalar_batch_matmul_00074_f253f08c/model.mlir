module {
  func.func @kernel(%arg0: tensor<8x128x64xf16>, %arg1: tensor<8x64x128xf16>, %arg2: tensor<8x128x128xf16>) -> tensor<8x128x128xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<8x128x128xf16> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<8x128x64xf16>, tensor<8x64x128xf16>) outs(%arg2 : tensor<8x128x128xf16>) -> tensor<8x128x128xf16>
      NAIL.yield %z : tensor<8x128x128xf16>
    }
    return %r : tensor<8x128x128xf16>
  }
}
