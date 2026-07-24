module {
  func.func @kernel(%arg0: tensor<3072x2304xbf16>, %arg1: tensor<2304x1216xbf16>, %arg2: tensor<3072x1216xf32>) -> tensor<3072x1216xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<3072x1216xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3072x2304xbf16>, tensor<2304x1216xbf16>) outs(%arg2 : tensor<3072x1216xf32>) -> tensor<3072x1216xf32>
      NAIL.yield %m : tensor<3072x1216xf32>
    }
    return %r : tensor<3072x1216xf32>
  }
}
