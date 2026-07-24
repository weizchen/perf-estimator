module {
  func.func @kernel(%arg0: tensor<8x1280x704xf16>, %arg1: tensor<8x704x448xf16>, %arg2: tensor<8x1280x448xf16>) -> tensor<8x1280x448xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<8x1280x448xf16> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<8x1280x704xf16>, tensor<8x704x448xf16>) outs(%arg2 : tensor<8x1280x448xf16>) -> tensor<8x1280x448xf16>
      NAIL.yield %z : tensor<8x1280x448xf16>
    }
    return %r : tensor<8x1280x448xf16>
  }
}
