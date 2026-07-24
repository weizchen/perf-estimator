module {
  func.func @kernel(%arg0: tensor<481x53xf32>, %arg1: tensor<481x53x122xf32>) -> tensor<481x53x122xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<481x53x122xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<481x53xf32>) outs(%arg1 : tensor<481x53x122xf32>) dimensions = [2]
      NAIL.yield %z : tensor<481x53x122xf32>
    }
    return %r : tensor<481x53x122xf32>
  }
}
