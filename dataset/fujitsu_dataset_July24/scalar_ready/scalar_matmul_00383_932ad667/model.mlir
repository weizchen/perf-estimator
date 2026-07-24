module {
  func.func @kernel(%arg0: tensor<1728x2688xf32>, %arg1: tensor<2688x3136xf32>, %arg2: tensor<1728x3136xf32>) -> tensor<1728x3136xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1728x3136xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1728x2688xf32>, tensor<2688x3136xf32>) outs(%arg2 : tensor<1728x3136xf32>) -> tensor<1728x3136xf32>
      NAIL.yield %m : tensor<1728x3136xf32>
    }
    return %r : tensor<1728x3136xf32>
  }
}
