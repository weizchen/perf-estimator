module {
  func.func @kernel(%arg0: tensor<8x6x23x4xf32>, %arg1: tensor<8x4x23x6xf32>) -> tensor<8x4x23x6xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<8x4x23x6xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<8x6x23x4xf32>) outs(%arg1 : tensor<8x4x23x6xf32>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<8x4x23x6xf32>
    }
    return %r : tensor<8x4x23x6xf32>
  }
}
