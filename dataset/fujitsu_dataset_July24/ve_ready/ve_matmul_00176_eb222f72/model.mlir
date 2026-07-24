module {
  func.func @kernel(%arg0: tensor<320x2304xf16>, %arg1: tensor<2304x704xf16>, %arg2: tensor<320x704xf32>) -> tensor<320x704xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<320x704xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x2304xf16>, tensor<2304x704xf16>) outs(%arg2 : tensor<320x704xf32>) -> tensor<320x704xf32>
      NAIL.yield %m : tensor<320x704xf32>
    }
    return %r : tensor<320x704xf32>
  }
}
