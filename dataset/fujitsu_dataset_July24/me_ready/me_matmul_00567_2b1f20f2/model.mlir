module {
  func.func @kernel(%arg0: tensor<256x1984xf16>, %arg1: tensor<1984x192xf16>, %arg2: tensor<256x192xf16>) -> tensor<256x192xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<256x192xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x1984xf16>, tensor<1984x192xf16>) outs(%arg2 : tensor<256x192xf16>) -> tensor<256x192xf16>
      NAIL.yield %m : tensor<256x192xf16>
    }
    return %r : tensor<256x192xf16>
  }
}
