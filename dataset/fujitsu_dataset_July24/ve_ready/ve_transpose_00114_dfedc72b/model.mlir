module {
  func.func @kernel(%arg0: tensor<33x8x5x14xf32>, %arg1: tensor<33x5x8x14xf32>) -> tensor<33x5x8x14xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<33x5x8x14xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<33x8x5x14xf32>) outs(%arg1 : tensor<33x5x8x14xf32>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<33x5x8x14xf32>
    }
    return %r : tensor<33x5x8x14xf32>
  }
}
