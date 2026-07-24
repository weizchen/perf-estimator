module {
  func.func @kernel(%arg0: tensor<704x640xf16>, %arg1: tensor<640x576xf16>, %arg2: tensor<704x576xf16>) -> tensor<704x576xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<704x576xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<704x640xf16>, tensor<640x576xf16>) outs(%arg2 : tensor<704x576xf16>) -> tensor<704x576xf16>
      NAIL.yield %m : tensor<704x576xf16>
    }
    return %r : tensor<704x576xf16>
  }
}
