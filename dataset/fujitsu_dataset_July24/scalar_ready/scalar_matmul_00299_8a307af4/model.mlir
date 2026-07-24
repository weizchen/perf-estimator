module {
  func.func @kernel(%arg0: tensor<2432x896xf16>, %arg1: tensor<896x704xf16>, %arg2: tensor<2432x704xf16>) -> tensor<2432x704xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2432x704xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2432x896xf16>, tensor<896x704xf16>) outs(%arg2 : tensor<2432x704xf16>) -> tensor<2432x704xf16>
      NAIL.yield %m : tensor<2432x704xf16>
    }
    return %r : tensor<2432x704xf16>
  }
}
