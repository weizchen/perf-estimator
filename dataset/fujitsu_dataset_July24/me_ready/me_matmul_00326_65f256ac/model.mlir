module {
  func.func @kernel(%arg0: tensor<128x3072xf16>, %arg1: tensor<3072x3328xf16>, %arg2: tensor<128x3328xf32>) -> tensor<128x3328xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<128x3328xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x3072xf16>, tensor<3072x3328xf16>) outs(%arg2 : tensor<128x3328xf32>) -> tensor<128x3328xf32>
      NAIL.yield %m : tensor<128x3328xf32>
    }
    return %r : tensor<128x3328xf32>
  }
}
