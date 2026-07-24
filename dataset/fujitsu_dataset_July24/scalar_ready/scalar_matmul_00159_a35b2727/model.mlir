module {
  func.func @kernel(%arg0: tensor<256x320xf16>, %arg1: tensor<320x1536xf16>, %arg2: tensor<256x1536xf32>) -> tensor<256x1536xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<256x1536xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x320xf16>, tensor<320x1536xf16>) outs(%arg2 : tensor<256x1536xf32>) -> tensor<256x1536xf32>
      NAIL.yield %m : tensor<256x1536xf32>
    }
    return %r : tensor<256x1536xf32>
  }
}
