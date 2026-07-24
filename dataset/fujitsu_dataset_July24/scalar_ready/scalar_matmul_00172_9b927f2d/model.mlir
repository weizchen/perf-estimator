module {
  func.func @kernel(%arg0: tensor<1792x64xf16>, %arg1: tensor<64x128xf16>, %arg2: tensor<1792x128xf32>) -> tensor<1792x128xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1792x128xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1792x64xf16>, tensor<64x128xf16>) outs(%arg2 : tensor<1792x128xf32>) -> tensor<1792x128xf32>
      NAIL.yield %m : tensor<1792x128xf32>
    }
    return %r : tensor<1792x128xf32>
  }
}
