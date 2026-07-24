module {
  func.func @kernel(%arg0: tensor<512x448xf16>, %arg1: tensor<448x64xf16>, %arg2: tensor<512x64xf32>) -> tensor<512x64xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<512x64xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x448xf16>, tensor<448x64xf16>) outs(%arg2 : tensor<512x64xf32>) -> tensor<512x64xf32>
      NAIL.yield %m : tensor<512x64xf32>
    }
    return %r : tensor<512x64xf32>
  }
}
