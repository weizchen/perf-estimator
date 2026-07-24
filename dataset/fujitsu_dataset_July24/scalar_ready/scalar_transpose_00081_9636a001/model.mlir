module {
  func.func @kernel(%arg0: tensor<61x5x4xf32>, %arg1: tensor<61x4x5xf32>) -> tensor<61x4x5xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<61x4x5xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<61x5x4xf32>) outs(%arg1 : tensor<61x4x5xf32>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<61x4x5xf32>
    }
    return %r : tensor<61x4x5xf32>
  }
}
