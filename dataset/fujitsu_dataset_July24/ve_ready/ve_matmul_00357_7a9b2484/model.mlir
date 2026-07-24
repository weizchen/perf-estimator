module {
  func.func @kernel(%arg0: tensor<1792x896xbf16>, %arg1: tensor<896x2112xbf16>, %arg2: tensor<1792x2112xf32>) -> tensor<1792x2112xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1792x2112xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1792x896xbf16>, tensor<896x2112xbf16>) outs(%arg2 : tensor<1792x2112xf32>) -> tensor<1792x2112xf32>
      NAIL.yield %m : tensor<1792x2112xf32>
    }
    return %r : tensor<1792x2112xf32>
  }
}
