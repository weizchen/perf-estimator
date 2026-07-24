module {
  func.func @kernel(%arg0: tensor<2304x1728xf16>, %arg1: tensor<1728x2304xf16>, %arg2: tensor<2304x2304xf32>) -> tensor<2304x2304xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<2304x2304xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2304x1728xf16>, tensor<1728x2304xf16>) outs(%arg2 : tensor<2304x2304xf32>) -> tensor<2304x2304xf32>
      NAIL.yield %m : tensor<2304x2304xf32>
    }
    return %r : tensor<2304x2304xf32>
  }
}
