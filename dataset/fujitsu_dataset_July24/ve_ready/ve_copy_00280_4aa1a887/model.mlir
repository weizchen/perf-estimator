module {
  func.func @kernel(%arg0: tensor<221x5x255xf32>, %arg1: tensor<221x5x255xf32>) -> tensor<221x5x255xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<221x5x255xf32> {
    %z = linalg.copy ins(%arg0 : tensor<221x5x255xf32>) outs(%arg1 : tensor<221x5x255xf32>) -> tensor<221x5x255xf32>
      NAIL.yield %z : tensor<221x5x255xf32>
    }
    return %r : tensor<221x5x255xf32>
  }
}
