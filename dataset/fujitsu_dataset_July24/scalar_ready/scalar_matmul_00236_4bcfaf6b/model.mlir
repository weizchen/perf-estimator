module {
  func.func @kernel(%arg0: tensor<704x1216xf16>, %arg1: tensor<1216x1344xf16>, %arg2: tensor<704x1344xf16>) -> tensor<704x1344xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<704x1344xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<704x1216xf16>, tensor<1216x1344xf16>) outs(%arg2 : tensor<704x1344xf16>) -> tensor<704x1344xf16>
      NAIL.yield %m : tensor<704x1344xf16>
    }
    return %r : tensor<704x1344xf16>
  }
}
