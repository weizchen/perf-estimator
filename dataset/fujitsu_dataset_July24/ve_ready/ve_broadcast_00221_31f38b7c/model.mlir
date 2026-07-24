module {
  func.func @kernel(%arg0: tensor<361x241xf32>, %arg1: tensor<4x361x241xf32>) -> tensor<4x361x241xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4x361x241xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<361x241xf32>) outs(%arg1 : tensor<4x361x241xf32>) dimensions = [0]
      NAIL.yield %z : tensor<4x361x241xf32>
    }
    return %r : tensor<4x361x241xf32>
  }
}
