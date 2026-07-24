module {
  func.func @kernel(%arg0: tensor<128x3136xf16>, %arg1: tensor<3136x1088xf16>, %arg2: tensor<128x1088xf32>) -> tensor<128x1088xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<128x1088xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x3136xf16>, tensor<3136x1088xf16>) outs(%arg2 : tensor<128x1088xf32>) -> tensor<128x1088xf32>
      NAIL.yield %m : tensor<128x1088xf32>
    }
    return %r : tensor<128x1088xf32>
  }
}
