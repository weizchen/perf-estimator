module {
  func.func @kernel(%arg0: tensor<768x192xbf16>, %arg1: tensor<192x4032xbf16>, %arg2: tensor<768x4032xf32>) -> tensor<768x4032xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<768x4032xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<768x192xbf16>, tensor<192x4032xbf16>) outs(%arg2 : tensor<768x4032xf32>) -> tensor<768x4032xf32>
      NAIL.yield %m : tensor<768x4032xf32>
    }
    return %r : tensor<768x4032xf32>
  }
}
