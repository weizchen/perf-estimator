module {
  func.func @kernel(%arg0: tensor<1536x64xbf16>, %arg1: tensor<64x2368xbf16>, %arg2: tensor<1536x2368xf16>) -> tensor<1536x2368xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1536x2368xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1536x64xbf16>, tensor<64x2368xbf16>) outs(%arg2 : tensor<1536x2368xf16>) -> tensor<1536x2368xf16>
      NAIL.yield %m : tensor<1536x2368xf16>
    }
    return %r : tensor<1536x2368xf16>
  }
}
