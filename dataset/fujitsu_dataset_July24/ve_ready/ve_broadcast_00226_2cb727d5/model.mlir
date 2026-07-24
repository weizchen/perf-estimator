module {
  func.func @kernel(%arg0: tensor<206xf32>, %arg1: tensor<206x10xf32>) -> tensor<206x10xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<206x10xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<206xf32>) outs(%arg1 : tensor<206x10xf32>) dimensions = [1]
      NAIL.yield %z : tensor<206x10xf32>
    }
    return %r : tensor<206x10xf32>
  }
}
