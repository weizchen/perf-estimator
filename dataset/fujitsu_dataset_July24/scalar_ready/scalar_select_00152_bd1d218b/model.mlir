module {
  func.func @kernel(%arg0: tensor<7xi1>, %arg1: tensor<7xf32>, %arg2: tensor<7xf32>, %arg3: tensor<7xf32>) -> tensor<7xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<7xf32> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<7xi1>, tensor<7xf32>, tensor<7xf32>) outs(%arg3 : tensor<7xf32>) -> tensor<7xf32>
      NAIL.yield %z : tensor<7xf32>
    }
    return %r : tensor<7xf32>
  }
}
