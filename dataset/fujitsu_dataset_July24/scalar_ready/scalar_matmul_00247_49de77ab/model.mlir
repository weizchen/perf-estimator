module {
  func.func @kernel(%arg0: tensor<2688x512xf16>, %arg1: tensor<512x3584xf16>, %arg2: tensor<2688x3584xf16>) -> tensor<2688x3584xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2688x3584xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2688x512xf16>, tensor<512x3584xf16>) outs(%arg2 : tensor<2688x3584xf16>) -> tensor<2688x3584xf16>
      NAIL.yield %m : tensor<2688x3584xf16>
    }
    return %r : tensor<2688x3584xf16>
  }
}
