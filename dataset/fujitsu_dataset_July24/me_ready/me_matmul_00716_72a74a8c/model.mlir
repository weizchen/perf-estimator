module {
  func.func @kernel(%arg0: tensor<192x960xf16>, %arg1: tensor<960x1408xf16>, %arg2: tensor<192x1408xf16>) -> tensor<192x1408xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<192x1408xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<192x960xf16>, tensor<960x1408xf16>) outs(%arg2 : tensor<192x1408xf16>) -> tensor<192x1408xf16>
      NAIL.yield %m : tensor<192x1408xf16>
    }
    return %r : tensor<192x1408xf16>
  }
}
