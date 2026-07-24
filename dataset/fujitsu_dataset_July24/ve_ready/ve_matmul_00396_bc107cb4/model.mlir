module {
  func.func @kernel(%arg0: tensor<3712x64xbf16>, %arg1: tensor<64x2688xbf16>, %arg2: tensor<3712x2688xf32>) -> tensor<3712x2688xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3712x2688xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3712x64xbf16>, tensor<64x2688xbf16>) outs(%arg2 : tensor<3712x2688xf32>) -> tensor<3712x2688xf32>
      NAIL.yield %m : tensor<3712x2688xf32>
    }
    return %r : tensor<3712x2688xf32>
  }
}
