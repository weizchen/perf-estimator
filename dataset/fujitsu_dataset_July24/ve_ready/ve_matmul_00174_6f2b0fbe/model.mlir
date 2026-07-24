module {
  func.func @kernel(%arg0: tensor<832x576xf16>, %arg1: tensor<576x256xf16>, %arg2: tensor<832x256xf32>) -> tensor<832x256xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<832x256xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<832x576xf16>, tensor<576x256xf16>) outs(%arg2 : tensor<832x256xf32>) -> tensor<832x256xf32>
      NAIL.yield %m : tensor<832x256xf32>
    }
    return %r : tensor<832x256xf32>
  }
}
