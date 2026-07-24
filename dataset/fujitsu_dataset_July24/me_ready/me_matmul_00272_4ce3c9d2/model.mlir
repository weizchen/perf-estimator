module {
  func.func @kernel(%arg0: tensor<128x1344xf16>, %arg1: tensor<1344x1920xf16>, %arg2: tensor<128x1920xf32>) -> tensor<128x1920xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<128x1920xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x1344xf16>, tensor<1344x1920xf16>) outs(%arg2 : tensor<128x1920xf32>) -> tensor<128x1920xf32>
      NAIL.yield %m : tensor<128x1920xf32>
    }
    return %r : tensor<128x1920xf32>
  }
}
