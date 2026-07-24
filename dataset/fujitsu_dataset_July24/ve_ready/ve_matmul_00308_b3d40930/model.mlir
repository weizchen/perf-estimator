module {
  func.func @kernel(%arg0: tensor<128x3584xbf16>, %arg1: tensor<3584x192xbf16>, %arg2: tensor<128x192xf32>) -> tensor<128x192xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<128x192xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x3584xbf16>, tensor<3584x192xbf16>) outs(%arg2 : tensor<128x192xf32>) -> tensor<128x192xf32>
      NAIL.yield %m : tensor<128x192xf32>
    }
    return %r : tensor<128x192xf32>
  }
}
