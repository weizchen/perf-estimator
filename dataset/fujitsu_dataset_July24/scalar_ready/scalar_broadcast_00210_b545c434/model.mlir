module {
  func.func @kernel(%arg0: tensor<138xf32>, %arg1: tensor<138x49xf32>) -> tensor<138x49xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<138x49xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<138xf32>) outs(%arg1 : tensor<138x49xf32>) dimensions = [1]
      NAIL.yield %z : tensor<138x49xf32>
    }
    return %r : tensor<138x49xf32>
  }
}
