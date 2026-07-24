module {
  func.func @kernel(%arg0: tensor<230x5xf32>, %arg1: tensor<81x230x5xf32>) -> tensor<81x230x5xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<81x230x5xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<230x5xf32>) outs(%arg1 : tensor<81x230x5xf32>) dimensions = [0]
      NAIL.yield %z : tensor<81x230x5xf32>
    }
    return %r : tensor<81x230x5xf32>
  }
}
