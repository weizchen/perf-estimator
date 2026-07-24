module {
  func.func @kernel(%arg0: tensor<384x4096xf32>, %arg1: tensor<4096x1728xf32>, %arg2: tensor<384x1728xf32>) -> tensor<384x1728xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<384x1728xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x4096xf32>, tensor<4096x1728xf32>) outs(%arg2 : tensor<384x1728xf32>) -> tensor<384x1728xf32>
      NAIL.yield %m : tensor<384x1728xf32>
    }
    return %r : tensor<384x1728xf32>
  }
}
