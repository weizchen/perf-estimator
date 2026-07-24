module {
  func.func @kernel(%arg0: tensor<256x2496xbf16>, %arg1: tensor<2496x832xbf16>, %arg2: tensor<256x832xf16>) -> tensor<256x832xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<256x832xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x2496xbf16>, tensor<2496x832xbf16>) outs(%arg2 : tensor<256x832xf16>) -> tensor<256x832xf16>
      NAIL.yield %m : tensor<256x832xf16>
    }
    return %r : tensor<256x832xf16>
  }
}
