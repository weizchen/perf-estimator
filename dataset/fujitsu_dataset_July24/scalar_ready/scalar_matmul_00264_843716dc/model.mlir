module {
  func.func @kernel(%arg0: tensor<704x576xf16>, %arg1: tensor<576x384xf16>, %arg2: tensor<704x384xf16>) -> tensor<704x384xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<704x384xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<704x576xf16>, tensor<576x384xf16>) outs(%arg2 : tensor<704x384xf16>) -> tensor<704x384xf16>
      NAIL.yield %m : tensor<704x384xf16>
    }
    return %r : tensor<704x384xf16>
  }
}
