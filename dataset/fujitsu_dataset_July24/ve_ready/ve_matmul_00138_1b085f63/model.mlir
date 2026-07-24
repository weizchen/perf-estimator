module {
  func.func @kernel(%arg0: tensor<3456x704xf16>, %arg1: tensor<704x128xf16>, %arg2: tensor<3456x128xf32>) -> tensor<3456x128xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3456x128xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3456x704xf16>, tensor<704x128xf16>) outs(%arg2 : tensor<3456x128xf32>) -> tensor<3456x128xf32>
      NAIL.yield %m : tensor<3456x128xf32>
    }
    return %r : tensor<3456x128xf32>
  }
}
