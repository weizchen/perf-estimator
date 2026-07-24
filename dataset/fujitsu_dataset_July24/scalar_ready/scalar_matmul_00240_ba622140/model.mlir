module {
  func.func @kernel(%arg0: tensor<3200x128xf16>, %arg1: tensor<128x640xf16>, %arg2: tensor<3200x640xf16>) -> tensor<3200x640xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<3200x640xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3200x128xf16>, tensor<128x640xf16>) outs(%arg2 : tensor<3200x640xf16>) -> tensor<3200x640xf16>
      NAIL.yield %m : tensor<3200x640xf16>
    }
    return %r : tensor<3200x640xf16>
  }
}
