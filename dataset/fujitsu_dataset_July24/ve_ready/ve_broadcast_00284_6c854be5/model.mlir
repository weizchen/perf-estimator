module {
  func.func @kernel(%arg0: tensor<20x36xf32>, %arg1: tensor<20x46x36xf32>) -> tensor<20x46x36xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<20x46x36xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<20x36xf32>) outs(%arg1 : tensor<20x46x36xf32>) dimensions = [1]
      NAIL.yield %z : tensor<20x46x36xf32>
    }
    return %r : tensor<20x46x36xf32>
  }
}
