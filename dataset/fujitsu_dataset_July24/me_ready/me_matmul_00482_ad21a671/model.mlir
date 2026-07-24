module {
  func.func @kernel(%arg0: tensor<640x2432xf16>, %arg1: tensor<2432x256xf16>, %arg2: tensor<640x256xf32>) -> tensor<640x256xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<640x256xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x2432xf16>, tensor<2432x256xf16>) outs(%arg2 : tensor<640x256xf32>) -> tensor<640x256xf32>
      NAIL.yield %m : tensor<640x256xf32>
    }
    return %r : tensor<640x256xf32>
  }
}
