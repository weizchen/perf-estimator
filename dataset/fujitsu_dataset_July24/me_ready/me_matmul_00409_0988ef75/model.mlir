module {
  func.func @kernel(%arg0: tensor<448x2432xf16>, %arg1: tensor<2432x128xf16>, %arg2: tensor<448x128xf32>) -> tensor<448x128xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<448x128xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<448x2432xf16>, tensor<2432x128xf16>) outs(%arg2 : tensor<448x128xf32>) -> tensor<448x128xf32>
      NAIL.yield %m : tensor<448x128xf32>
    }
    return %r : tensor<448x128xf32>
  }
}
