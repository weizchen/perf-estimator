module {
  func.func @kernel(%arg0: tensor<4096x192xf16>, %arg1: tensor<192x128xf16>, %arg2: tensor<4096x128xf16>) -> tensor<4096x128xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4096x128xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<4096x192xf16>, tensor<192x128xf16>) outs(%arg2 : tensor<4096x128xf16>) -> tensor<4096x128xf16>
      NAIL.yield %m : tensor<4096x128xf16>
    }
    return %r : tensor<4096x128xf16>
  }
}
