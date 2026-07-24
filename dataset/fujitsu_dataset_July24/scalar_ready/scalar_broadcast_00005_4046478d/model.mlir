module {
  func.func @kernel(%arg0: tensor<266x14xf32>, %arg1: tensor<266x14x198xf32>) -> tensor<266x14x198xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<266x14x198xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<266x14xf32>) outs(%arg1 : tensor<266x14x198xf32>) dimensions = [2]
      NAIL.yield %z : tensor<266x14x198xf32>
    }
    return %r : tensor<266x14x198xf32>
  }
}
