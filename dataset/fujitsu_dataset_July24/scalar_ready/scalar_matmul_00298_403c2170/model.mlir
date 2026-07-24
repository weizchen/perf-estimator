module {
  func.func @kernel(%arg0: tensor<448x2688xf16>, %arg1: tensor<2688x3648xf16>, %arg2: tensor<448x3648xf16>) -> tensor<448x3648xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<448x3648xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<448x2688xf16>, tensor<2688x3648xf16>) outs(%arg2 : tensor<448x3648xf16>) -> tensor<448x3648xf16>
      NAIL.yield %m : tensor<448x3648xf16>
    }
    return %r : tensor<448x3648xf16>
  }
}
