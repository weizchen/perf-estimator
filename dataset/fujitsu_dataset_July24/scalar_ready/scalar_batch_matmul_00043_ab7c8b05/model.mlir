module {
  func.func @kernel(%arg0: tensor<2x448x64xf16>, %arg1: tensor<2x64x448xf16>, %arg2: tensor<2x448x448xf32>) -> tensor<2x448x448xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x448x448xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x448x64xf16>, tensor<2x64x448xf16>) outs(%arg2 : tensor<2x448x448xf32>) -> tensor<2x448x448xf32>
      NAIL.yield %z : tensor<2x448x448xf32>
    }
    return %r : tensor<2x448x448xf32>
  }
}
