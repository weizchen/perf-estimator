module {
  func.func @kernel(%arg0: tensor<34xf32>, %arg1: tensor<34xf32>) -> tensor<34xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<34xf32> {
    %z = linalg.copy ins(%arg0 : tensor<34xf32>) outs(%arg1 : tensor<34xf32>) -> tensor<34xf32>
      NAIL.yield %z : tensor<34xf32>
    }
    return %r : tensor<34xf32>
  }
}
