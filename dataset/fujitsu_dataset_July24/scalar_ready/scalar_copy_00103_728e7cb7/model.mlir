module {
  func.func @kernel(%arg0: tensor<24xf32>, %arg1: tensor<24xf32>) -> tensor<24xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<24xf32> {
    %z = linalg.copy ins(%arg0 : tensor<24xf32>) outs(%arg1 : tensor<24xf32>) -> tensor<24xf32>
      NAIL.yield %z : tensor<24xf32>
    }
    return %r : tensor<24xf32>
  }
}
