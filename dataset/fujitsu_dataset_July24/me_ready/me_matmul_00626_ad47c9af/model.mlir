module {
  func.func @kernel(%arg0: tensor<1408x448xf16>, %arg1: tensor<448x192xf16>, %arg2: tensor<1408x192xf16>) -> tensor<1408x192xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1408x192xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1408x448xf16>, tensor<448x192xf16>) outs(%arg2 : tensor<1408x192xf16>) -> tensor<1408x192xf16>
      NAIL.yield %m : tensor<1408x192xf16>
    }
    return %r : tensor<1408x192xf16>
  }
}
