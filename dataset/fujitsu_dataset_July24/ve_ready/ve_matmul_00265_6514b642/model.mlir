module {
  func.func @kernel(%arg0: tensor<576x704xf16>, %arg1: tensor<704x3968xf16>, %arg2: tensor<576x3968xf16>) -> tensor<576x3968xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<576x3968xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<576x704xf16>, tensor<704x3968xf16>) outs(%arg2 : tensor<576x3968xf16>) -> tensor<576x3968xf16>
      NAIL.yield %m : tensor<576x3968xf16>
    }
    return %r : tensor<576x3968xf16>
  }
}
