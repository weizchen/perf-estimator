module {
  func.func @kernel(%arg0: tensor<704x832xf16>, %arg1: tensor<832x1088xf16>, %arg2: tensor<704x1088xf32>) -> tensor<704x1088xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<704x1088xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<704x832xf16>, tensor<832x1088xf16>) outs(%arg2 : tensor<704x1088xf32>) -> tensor<704x1088xf32>
      NAIL.yield %m : tensor<704x1088xf32>
    }
    return %r : tensor<704x1088xf32>
  }
}
