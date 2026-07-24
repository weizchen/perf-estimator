module {
  func.func @kernel(%arg0: tensor<89x24xi1>, %arg1: tensor<89x24xf32>, %arg2: tensor<89x24xf32>, %arg3: tensor<89x24xf32>) -> tensor<89x24xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<89x24xf32> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<89x24xi1>, tensor<89x24xf32>, tensor<89x24xf32>) outs(%arg3 : tensor<89x24xf32>) -> tensor<89x24xf32>
      NAIL.yield %z : tensor<89x24xf32>
    }
    return %r : tensor<89x24xf32>
  }
}
