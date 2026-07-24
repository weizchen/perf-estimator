module {
  func.func @kernel(%arg0: tensor<4x128x64xf16>, %arg1: tensor<4x64x640xf16>, %arg2: tensor<4x128x640xf16>) -> tensor<4x128x640xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x128x640xf16> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<4x128x64xf16>, tensor<4x64x640xf16>) outs(%arg2 : tensor<4x128x640xf16>) -> tensor<4x128x640xf16>
      NAIL.yield %z : tensor<4x128x640xf16>
    }
    return %r : tensor<4x128x640xf16>
  }
}
