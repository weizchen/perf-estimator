module {
  func.func @kernel(%arg0: tensor<1088x256xf32>, %arg1: tensor<256xf32>, %arg2: tensor<1088xf32>) -> tensor<1088xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1088xf32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<1088x256xf32>, tensor<256xf32>) outs(%arg2 : tensor<1088xf32>) -> tensor<1088xf32>
      NAIL.yield %z : tensor<1088xf32>
    }
    return %r : tensor<1088xf32>
  }
}
