module {
  func.func @kernel(%arg0: tensor<256x64xf16>, %arg1: tensor<64x448xf16>, %arg2: tensor<256x448xf32>) -> tensor<256x448xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<256x448xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x64xf16>, tensor<64x448xf16>) outs(%arg2 : tensor<256x448xf32>) -> tensor<256x448xf32>
      NAIL.yield %m : tensor<256x448xf32>
    }
    return %r : tensor<256x448xf32>
  }
}
