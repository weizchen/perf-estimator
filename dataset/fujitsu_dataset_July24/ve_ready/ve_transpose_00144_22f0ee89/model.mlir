module {
  func.func @kernel(%arg0: tensor<125x5x90xf32>, %arg1: tensor<90x5x125xf32>) -> tensor<90x5x125xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<90x5x125xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<125x5x90xf32>) outs(%arg1 : tensor<90x5x125xf32>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<90x5x125xf32>
    }
    return %r : tensor<90x5x125xf32>
  }
}
