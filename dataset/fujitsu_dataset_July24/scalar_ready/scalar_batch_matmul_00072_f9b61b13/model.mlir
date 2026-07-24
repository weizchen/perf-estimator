module {
  func.func @kernel(%arg0: tensor<1x192x1920xf16>, %arg1: tensor<1x1920x320xf16>, %arg2: tensor<1x192x320xf16>) -> tensor<1x192x320xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1x192x320xf16> {
    %z = linalg.batch_matmul ins(%arg0, %arg1 : tensor<1x192x1920xf16>, tensor<1x1920x320xf16>) outs(%arg2 : tensor<1x192x320xf16>) -> tensor<1x192x320xf16>
      NAIL.yield %z : tensor<1x192x320xf16>
    }
    return %r : tensor<1x192x320xf16>
  }
}
