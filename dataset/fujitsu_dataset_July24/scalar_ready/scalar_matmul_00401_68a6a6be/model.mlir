module {
  func.func @kernel(%arg0: tensor<1280x2176xf32>, %arg1: tensor<2176x1600xf32>, %arg2: tensor<1280x1600xf32>) -> tensor<1280x1600xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1280x1600xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1280x2176xf32>, tensor<2176x1600xf32>) outs(%arg2 : tensor<1280x1600xf32>) -> tensor<1280x1600xf32>
      NAIL.yield %m : tensor<1280x1600xf32>
    }
    return %r : tensor<1280x1600xf32>
  }
}
