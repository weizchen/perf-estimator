module {
  func.func @kernel(%arg0: tensor<3328x512xf16>, %arg1: tensor<512x3520xf16>, %arg2: tensor<3328x3520xf32>) -> tensor<3328x3520xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<3328x3520xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3328x512xf16>, tensor<512x3520xf16>) outs(%arg2 : tensor<3328x3520xf32>) -> tensor<3328x3520xf32>
      NAIL.yield %m : tensor<3328x3520xf32>
    }
    return %r : tensor<3328x3520xf32>
  }
}
