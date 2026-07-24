module {
  func.func @kernel(%arg0: tensor<832x256xf16>, %arg1: tensor<256x2112xf16>, %arg2: tensor<832x2112xf32>) -> tensor<832x2112xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<832x2112xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<832x256xf16>, tensor<256x2112xf16>) outs(%arg2 : tensor<832x2112xf32>) -> tensor<832x2112xf32>
      NAIL.yield %m : tensor<832x2112xf32>
    }
    return %r : tensor<832x2112xf32>
  }
}
