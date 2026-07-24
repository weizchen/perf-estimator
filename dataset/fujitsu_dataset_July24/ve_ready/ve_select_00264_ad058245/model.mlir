module {
  func.func @kernel(%arg0: tensor<10xi1>, %arg1: tensor<10xf32>, %arg2: tensor<10xf32>, %arg3: tensor<10xf32>) -> tensor<10xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<10xf32> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<10xi1>, tensor<10xf32>, tensor<10xf32>) outs(%arg3 : tensor<10xf32>) -> tensor<10xf32>
      NAIL.yield %z : tensor<10xf32>
    }
    return %r : tensor<10xf32>
  }
}
