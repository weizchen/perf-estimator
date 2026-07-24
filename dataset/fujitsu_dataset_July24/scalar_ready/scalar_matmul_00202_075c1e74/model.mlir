module {
  func.func @kernel(%arg0: tensor<2752x704xf16>, %arg1: tensor<704x384xf16>, %arg2: tensor<2752x384xf32>) -> tensor<2752x384xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2752x384xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2752x704xf16>, tensor<704x384xf16>) outs(%arg2 : tensor<2752x384xf32>) -> tensor<2752x384xf32>
      NAIL.yield %m : tensor<2752x384xf32>
    }
    return %r : tensor<2752x384xf32>
  }
}
