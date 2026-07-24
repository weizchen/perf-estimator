module {
  func.func @kernel(%arg0: tensor<393x8xi1>, %arg1: tensor<393x8xf32>, %arg2: tensor<393x8xf32>, %arg3: tensor<393x8xf32>) -> tensor<393x8xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<393x8xf32> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<393x8xi1>, tensor<393x8xf32>, tensor<393x8xf32>) outs(%arg3 : tensor<393x8xf32>) -> tensor<393x8xf32>
      NAIL.yield %z : tensor<393x8xf32>
    }
    return %r : tensor<393x8xf32>
  }
}
