module {
  func.func @kernel(%arg0: tensor<3648x3968xbf16>, %arg1: tensor<3968x2048xbf16>, %arg2: tensor<3648x2048xf32>) -> tensor<3648x2048xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<3648x2048xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3648x3968xbf16>, tensor<3968x2048xbf16>) outs(%arg2 : tensor<3648x2048xf32>) -> tensor<3648x2048xf32>
      NAIL.yield %m : tensor<3648x2048xf32>
    }
    return %r : tensor<3648x2048xf32>
  }
}
