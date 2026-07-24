module {
  func.func @kernel(%arg0: tensor<512x3904xf16>, %arg1: tensor<3904x448xf16>, %arg2: tensor<512x448xf32>) -> tensor<512x448xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<512x448xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x3904xf16>, tensor<3904x448xf16>) outs(%arg2 : tensor<512x448xf32>) -> tensor<512x448xf32>
      NAIL.yield %m : tensor<512x448xf32>
    }
    return %r : tensor<512x448xf32>
  }
}
