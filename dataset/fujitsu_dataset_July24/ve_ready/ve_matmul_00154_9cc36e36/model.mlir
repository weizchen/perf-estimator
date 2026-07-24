module {
  func.func @kernel(%arg0: tensor<896x768xf16>, %arg1: tensor<768x2048xf16>, %arg2: tensor<896x2048xf32>) -> tensor<896x2048xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<896x2048xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<896x768xf16>, tensor<768x2048xf16>) outs(%arg2 : tensor<896x2048xf32>) -> tensor<896x2048xf32>
      NAIL.yield %m : tensor<896x2048xf32>
    }
    return %r : tensor<896x2048xf32>
  }
}
