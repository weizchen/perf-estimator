module {
  func.func @kernel(%arg0: tensor<6x8x18xf32>, %arg1: tensor<18x8x6xf32>) -> tensor<18x8x6xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<18x8x6xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<6x8x18xf32>) outs(%arg1 : tensor<18x8x6xf32>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<18x8x6xf32>
    }
    return %r : tensor<18x8x6xf32>
  }
}
