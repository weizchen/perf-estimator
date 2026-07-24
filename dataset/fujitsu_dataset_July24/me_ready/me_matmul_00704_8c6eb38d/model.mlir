module {
  func.func @kernel(%arg0: tensor<1024x576xf16>, %arg1: tensor<576x640xf16>, %arg2: tensor<1024x640xf16>) -> tensor<1024x640xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1024x640xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1024x576xf16>, tensor<576x640xf16>) outs(%arg2 : tensor<1024x640xf16>) -> tensor<1024x640xf16>
      NAIL.yield %m : tensor<1024x640xf16>
    }
    return %r : tensor<1024x640xf16>
  }
}
