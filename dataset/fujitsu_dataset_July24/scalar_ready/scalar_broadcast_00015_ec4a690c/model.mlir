module {
  func.func @kernel(%arg0: tensor<35x502xf32>, %arg1: tensor<35x98x502xf32>) -> tensor<35x98x502xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<35x98x502xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<35x502xf32>) outs(%arg1 : tensor<35x98x502xf32>) dimensions = [1]
      NAIL.yield %z : tensor<35x98x502xf32>
    }
    return %r : tensor<35x98x502xf32>
  }
}
