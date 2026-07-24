module {
  func.func @kernel(%arg0: tensor<128x704xf32>, %arg1: tensor<704x512xf32>, %arg2: tensor<128x512xf32>) -> tensor<128x512xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<128x512xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x704xf32>, tensor<704x512xf32>) outs(%arg2 : tensor<128x512xf32>) -> tensor<128x512xf32>
      NAIL.yield %m : tensor<128x512xf32>
    }
    return %r : tensor<128x512xf32>
  }
}
