module {
  func.func @kernel(%arg0: tensor<704x2048xf16>, %arg1: tensor<2048x4032xf16>, %arg2: tensor<704x4032xf32>) -> tensor<704x4032xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<704x4032xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<704x2048xf16>, tensor<2048x4032xf16>) outs(%arg2 : tensor<704x4032xf32>) -> tensor<704x4032xf32>
      NAIL.yield %m : tensor<704x4032xf32>
    }
    return %r : tensor<704x4032xf32>
  }
}
