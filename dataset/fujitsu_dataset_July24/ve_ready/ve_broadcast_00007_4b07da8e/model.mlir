module {
  func.func @kernel(%arg0: tensor<235xf32>, %arg1: tensor<6x235xf32>) -> tensor<6x235xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<6x235xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<235xf32>) outs(%arg1 : tensor<6x235xf32>) dimensions = [0]
      NAIL.yield %z : tensor<6x235xf32>
    }
    return %r : tensor<6x235xf32>
  }
}
