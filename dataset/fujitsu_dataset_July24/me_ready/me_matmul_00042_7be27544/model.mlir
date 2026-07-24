module {
  func.func @kernel(%arg0: tensor<3584x256xf8E5M2>, %arg1: tensor<256x256xf8E5M2>, %arg2: tensor<3584x256xf32>) -> tensor<3584x256xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<3584x256xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3584x256xf8E5M2>, tensor<256x256xf8E5M2>) outs(%arg2 : tensor<3584x256xf32>) -> tensor<3584x256xf32>
      NAIL.yield %m : tensor<3584x256xf32>
    }
    return %r : tensor<3584x256xf32>
  }
}
