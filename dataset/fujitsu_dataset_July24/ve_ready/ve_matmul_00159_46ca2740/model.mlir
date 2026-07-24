module {
  func.func @kernel(%arg0: tensor<2240x1536xf16>, %arg1: tensor<1536x704xf16>, %arg2: tensor<2240x704xf32>) -> tensor<2240x704xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2240x704xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2240x1536xf16>, tensor<1536x704xf16>) outs(%arg2 : tensor<2240x704xf32>) -> tensor<2240x704xf32>
      NAIL.yield %m : tensor<2240x704xf32>
    }
    return %r : tensor<2240x704xf32>
  }
}
