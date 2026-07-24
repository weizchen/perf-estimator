module {
  func.func @kernel(%arg0: tensor<64x1216xbf16>, %arg1: tensor<1216x64xbf16>, %arg2: tensor<64x64xf32>) -> tensor<64x64xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<64x64xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x1216xbf16>, tensor<1216x64xbf16>) outs(%arg2 : tensor<64x64xf32>) -> tensor<64x64xf32>
      NAIL.yield %m : tensor<64x64xf32>
    }
    return %r : tensor<64x64xf32>
  }
}
