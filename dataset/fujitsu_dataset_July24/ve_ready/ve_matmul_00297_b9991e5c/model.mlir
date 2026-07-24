module {
  func.func @kernel(%arg0: tensor<2688x3008xf16>, %arg1: tensor<3008x2176xf16>, %arg2: tensor<2688x2176xf16>) -> tensor<2688x2176xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2688x2176xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2688x3008xf16>, tensor<3008x2176xf16>) outs(%arg2 : tensor<2688x2176xf16>) -> tensor<2688x2176xf16>
      NAIL.yield %m : tensor<2688x2176xf16>
    }
    return %r : tensor<2688x2176xf16>
  }
}
