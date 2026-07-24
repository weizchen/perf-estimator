module {
  func.func @kernel(%arg0: tensor<64x896xbf16>, %arg1: tensor<896x640xbf16>, %arg2: tensor<64x640xf16>) -> tensor<64x640xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<64x640xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x896xbf16>, tensor<896x640xbf16>) outs(%arg2 : tensor<64x640xf16>) -> tensor<64x640xf16>
      NAIL.yield %m : tensor<64x640xf16>
    }
    return %r : tensor<64x640xf16>
  }
}
