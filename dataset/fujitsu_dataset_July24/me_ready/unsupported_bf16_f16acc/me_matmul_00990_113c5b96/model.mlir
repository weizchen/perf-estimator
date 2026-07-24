module {
  func.func @kernel(%arg0: tensor<1216x1280xbf16>, %arg1: tensor<1280x3968xbf16>, %arg2: tensor<1216x3968xf16>) -> tensor<1216x3968xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1216x3968xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1216x1280xbf16>, tensor<1280x3968xbf16>) outs(%arg2 : tensor<1216x3968xf16>) -> tensor<1216x3968xf16>
      NAIL.yield %m : tensor<1216x3968xf16>
    }
    return %r : tensor<1216x3968xf16>
  }
}
