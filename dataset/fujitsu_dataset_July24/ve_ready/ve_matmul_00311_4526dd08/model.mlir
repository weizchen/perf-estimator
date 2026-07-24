module {
  func.func @kernel(%arg0: tensor<2048x64xbf16>, %arg1: tensor<64x832xbf16>, %arg2: tensor<2048x832xf32>) -> tensor<2048x832xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2048x832xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2048x64xbf16>, tensor<64x832xbf16>) outs(%arg2 : tensor<2048x832xf32>) -> tensor<2048x832xf32>
      NAIL.yield %m : tensor<2048x832xf32>
    }
    return %r : tensor<2048x832xf32>
  }
}
