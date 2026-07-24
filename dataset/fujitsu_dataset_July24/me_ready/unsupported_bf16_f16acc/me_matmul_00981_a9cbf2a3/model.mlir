module {
  func.func @kernel(%arg0: tensor<512x1856xbf16>, %arg1: tensor<1856x3328xbf16>, %arg2: tensor<512x3328xf16>) -> tensor<512x3328xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<512x3328xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x1856xbf16>, tensor<1856x3328xbf16>) outs(%arg2 : tensor<512x3328xf16>) -> tensor<512x3328xf16>
      NAIL.yield %m : tensor<512x3328xf16>
    }
    return %r : tensor<512x3328xf16>
  }
}
