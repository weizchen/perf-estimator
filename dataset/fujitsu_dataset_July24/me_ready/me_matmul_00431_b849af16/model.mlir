module {
  func.func @kernel(%arg0: tensor<768x4032xf16>, %arg1: tensor<4032x192xf16>, %arg2: tensor<768x192xf32>) -> tensor<768x192xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<768x192xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<768x4032xf16>, tensor<4032x192xf16>) outs(%arg2 : tensor<768x192xf32>) -> tensor<768x192xf32>
      NAIL.yield %m : tensor<768x192xf32>
    }
    return %r : tensor<768x192xf32>
  }
}
