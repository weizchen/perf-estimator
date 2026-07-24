module {
  func.func @kernel(%arg0: tensor<768x832xf16>, %arg1: tensor<832x448xf16>, %arg2: tensor<768x448xf16>) -> tensor<768x448xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<768x448xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<768x832xf16>, tensor<832x448xf16>) outs(%arg2 : tensor<768x448xf16>) -> tensor<768x448xf16>
      NAIL.yield %m : tensor<768x448xf16>
    }
    return %r : tensor<768x448xf16>
  }
}
