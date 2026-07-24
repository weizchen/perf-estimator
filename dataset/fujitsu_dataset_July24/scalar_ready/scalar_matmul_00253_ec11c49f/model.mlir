module {
  func.func @kernel(%arg0: tensor<64x768xf16>, %arg1: tensor<768x3584xf16>, %arg2: tensor<64x3584xf16>) -> tensor<64x3584xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<64x3584xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x768xf16>, tensor<768x3584xf16>) outs(%arg2 : tensor<64x3584xf16>) -> tensor<64x3584xf16>
      NAIL.yield %m : tensor<64x3584xf16>
    }
    return %r : tensor<64x3584xf16>
  }
}
