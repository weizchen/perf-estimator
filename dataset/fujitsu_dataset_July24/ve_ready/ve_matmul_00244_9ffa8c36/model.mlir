module {
  func.func @kernel(%arg0: tensor<576x64xf16>, %arg1: tensor<64x1792xf16>, %arg2: tensor<576x1792xf16>) -> tensor<576x1792xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<576x1792xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<576x64xf16>, tensor<64x1792xf16>) outs(%arg2 : tensor<576x1792xf16>) -> tensor<576x1792xf16>
      NAIL.yield %m : tensor<576x1792xf16>
    }
    return %r : tensor<576x1792xf16>
  }
}
