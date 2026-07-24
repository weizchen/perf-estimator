module {
  func.func @kernel(%arg0: tensor<347x13xf32>, %arg1: tensor<347x5x13xf32>) -> tensor<347x5x13xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<347x5x13xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<347x13xf32>) outs(%arg1 : tensor<347x5x13xf32>) dimensions = [1]
      NAIL.yield %z : tensor<347x5x13xf32>
    }
    return %r : tensor<347x5x13xf32>
  }
}
