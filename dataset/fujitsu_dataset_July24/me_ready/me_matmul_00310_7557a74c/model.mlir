module {
  func.func @kernel(%arg0: tensor<3712x1600xf16>, %arg1: tensor<1600x704xf16>, %arg2: tensor<3712x704xf32>) -> tensor<3712x704xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<3712x704xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3712x1600xf16>, tensor<1600x704xf16>) outs(%arg2 : tensor<3712x704xf32>) -> tensor<3712x704xf32>
      NAIL.yield %m : tensor<3712x704xf32>
    }
    return %r : tensor<3712x704xf32>
  }
}
