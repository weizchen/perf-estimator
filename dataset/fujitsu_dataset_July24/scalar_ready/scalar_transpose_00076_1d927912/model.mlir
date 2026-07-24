module {
  func.func @kernel(%arg0: tensor<5x26x13xf32>, %arg1: tensor<26x5x13xf32>) -> tensor<26x5x13xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<26x5x13xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<5x26x13xf32>) outs(%arg1 : tensor<26x5x13xf32>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<26x5x13xf32>
    }
    return %r : tensor<26x5x13xf32>
  }
}
