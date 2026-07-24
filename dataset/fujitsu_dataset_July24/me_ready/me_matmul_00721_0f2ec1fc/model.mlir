module {
  func.func @kernel(%arg0: tensor<2496x448xf16>, %arg1: tensor<448x2880xf16>, %arg2: tensor<2496x2880xf16>) -> tensor<2496x2880xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<2496x2880xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2496x448xf16>, tensor<448x2880xf16>) outs(%arg2 : tensor<2496x2880xf16>) -> tensor<2496x2880xf16>
      NAIL.yield %m : tensor<2496x2880xf16>
    }
    return %r : tensor<2496x2880xf16>
  }
}
