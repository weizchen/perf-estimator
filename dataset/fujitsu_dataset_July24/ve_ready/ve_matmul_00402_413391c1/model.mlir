module {
  func.func @kernel(%arg0: tensor<384x640xf32>, %arg1: tensor<640x704xf32>, %arg2: tensor<384x704xf32>) -> tensor<384x704xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<384x704xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x640xf32>, tensor<640x704xf32>) outs(%arg2 : tensor<384x704xf32>) -> tensor<384x704xf32>
      NAIL.yield %m : tensor<384x704xf32>
    }
    return %r : tensor<384x704xf32>
  }
}
