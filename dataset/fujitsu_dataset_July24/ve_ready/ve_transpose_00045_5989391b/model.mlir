module {
  func.func @kernel(%arg0: tensor<27x106x103xf32>, %arg1: tensor<27x103x106xf32>) -> tensor<27x103x106xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<27x103x106xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<27x106x103xf32>) outs(%arg1 : tensor<27x103x106xf32>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<27x103x106xf32>
    }
    return %r : tensor<27x103x106xf32>
  }
}
