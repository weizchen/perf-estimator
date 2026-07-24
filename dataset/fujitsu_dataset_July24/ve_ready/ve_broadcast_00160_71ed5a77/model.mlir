module {
  func.func @kernel(%arg0: tensor<7x91xf32>, %arg1: tensor<258x7x91xf32>) -> tensor<258x7x91xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<258x7x91xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<7x91xf32>) outs(%arg1 : tensor<258x7x91xf32>) dimensions = [0]
      NAIL.yield %z : tensor<258x7x91xf32>
    }
    return %r : tensor<258x7x91xf32>
  }
}
