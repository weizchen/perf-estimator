module {
  func.func @kernel(%arg0: tensor<2x384x320xf16>, %arg1: tensor<2x320x768xf16>, %arg2: tensor<2x384x768xf16>) -> tensor<2x384x768xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x384x768xf16> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x384x320xf16>, tensor<2x320x768xf16>) outs(%arg2 : tensor<2x384x768xf16>) -> tensor<2x384x768xf16>
      NAIL.yield %z : tensor<2x384x768xf16>
    }
    return %r : tensor<2x384x768xf16>
  }
}
