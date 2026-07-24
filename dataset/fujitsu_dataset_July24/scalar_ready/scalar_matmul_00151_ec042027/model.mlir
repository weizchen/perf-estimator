module {
  func.func @kernel(%arg0: tensor<256x2880xf16>, %arg1: tensor<2880x2496xf16>, %arg2: tensor<256x2496xf32>) -> tensor<256x2496xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<256x2496xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x2880xf16>, tensor<2880x2496xf16>) outs(%arg2 : tensor<256x2496xf32>) -> tensor<256x2496xf32>
      NAIL.yield %m : tensor<256x2496xf32>
    }
    return %r : tensor<256x2496xf32>
  }
}
