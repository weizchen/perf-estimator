module {
  func.func @kernel(%arg0: tensor<21x68xf32>, %arg1: tensor<401x21x68xf32>) -> tensor<401x21x68xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<401x21x68xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<21x68xf32>) outs(%arg1 : tensor<401x21x68xf32>) dimensions = [0]
      NAIL.yield %z : tensor<401x21x68xf32>
    }
    return %r : tensor<401x21x68xf32>
  }
}
