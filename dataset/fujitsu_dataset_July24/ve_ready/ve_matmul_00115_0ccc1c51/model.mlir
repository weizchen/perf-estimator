module {
  func.func @kernel(%arg0: tensor<2752x1792xf16>, %arg1: tensor<1792x2752xf16>, %arg2: tensor<2752x2752xf32>) -> tensor<2752x2752xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2752x2752xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2752x1792xf16>, tensor<1792x2752xf16>) outs(%arg2 : tensor<2752x2752xf32>) -> tensor<2752x2752xf32>
      NAIL.yield %m : tensor<2752x2752xf32>
    }
    return %r : tensor<2752x2752xf32>
  }
}
