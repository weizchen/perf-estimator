module {
  func.func @kernel(%arg0: tensor<640x3520xf16>, %arg1: tensor<3520x1536xf16>, %arg2: tensor<640x1536xf32>) -> tensor<640x1536xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<640x1536xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x3520xf16>, tensor<3520x1536xf16>) outs(%arg2 : tensor<640x1536xf32>) -> tensor<640x1536xf32>
      NAIL.yield %m : tensor<640x1536xf32>
    }
    return %r : tensor<640x1536xf32>
  }
}
