module {
  func.func @kernel(%arg0: tensor<896x896xf16>, %arg1: tensor<896x3136xf16>, %arg2: tensor<896x3136xf32>) -> tensor<896x3136xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<896x3136xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<896x896xf16>, tensor<896x3136xf16>) outs(%arg2 : tensor<896x3136xf32>) -> tensor<896x3136xf32>
      NAIL.yield %m : tensor<896x3136xf32>
    }
    return %r : tensor<896x3136xf32>
  }
}
