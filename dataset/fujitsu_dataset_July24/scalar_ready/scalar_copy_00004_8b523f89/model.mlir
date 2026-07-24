module {
  func.func @kernel(%arg0: tensor<6x32x77xf32>, %arg1: tensor<6x32x77xf32>) -> tensor<6x32x77xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<6x32x77xf32> {
    %z = linalg.copy ins(%arg0 : tensor<6x32x77xf32>) outs(%arg1 : tensor<6x32x77xf32>) -> tensor<6x32x77xf32>
      NAIL.yield %z : tensor<6x32x77xf32>
    }
    return %r : tensor<6x32x77xf32>
  }
}
