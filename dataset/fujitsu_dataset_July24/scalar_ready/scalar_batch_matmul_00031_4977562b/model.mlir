module {
  func.func @kernel(%arg0: tensor<2x1920x448xf16>, %arg1: tensor<2x448x128xf16>, %arg2: tensor<2x1920x128xf32>) -> tensor<2x1920x128xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2x1920x128xf32> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<2x1920x448xf16>, tensor<2x448x128xf16>) outs(%arg2 : tensor<2x1920x128xf32>) -> tensor<2x1920x128xf32>
      NAIL.yield %z : tensor<2x1920x128xf32>
    }
    return %r : tensor<2x1920x128xf32>
  }
}
