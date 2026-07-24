module {
  func.func @kernel(%arg0: tensor<832x64xbf16>, %arg1: tensor<64x3136xbf16>, %arg2: tensor<832x3136xf16>) -> tensor<832x3136xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<832x3136xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<832x64xbf16>, tensor<64x3136xbf16>) outs(%arg2 : tensor<832x3136xf16>) -> tensor<832x3136xf16>
      NAIL.yield %m : tensor<832x3136xf16>
    }
    return %r : tensor<832x3136xf16>
  }
}
