module {
  func.func @kernel(%arg0: tensor<2112x1408xf16>, %arg1: tensor<1408x448xf16>, %arg2: tensor<2112x448xf16>) -> tensor<2112x448xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<2112x448xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2112x1408xf16>, tensor<1408x448xf16>) outs(%arg2 : tensor<2112x448xf16>) -> tensor<2112x448xf16>
      NAIL.yield %m : tensor<2112x448xf16>
    }
    return %r : tensor<2112x448xf16>
  }
}
