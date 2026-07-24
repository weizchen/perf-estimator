module {
  func.func @kernel(%arg0: tensor<23x205xf32>, %arg1: tensor<23x87x205xf32>) -> tensor<23x87x205xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<23x87x205xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<23x205xf32>) outs(%arg1 : tensor<23x87x205xf32>) dimensions = [1]
      NAIL.yield %z : tensor<23x87x205xf32>
    }
    return %r : tensor<23x87x205xf32>
  }
}
