module {
  func.func @kernel(%arg0: tensor<640x448xf32>, %arg1: tensor<448x64xf32>, %arg2: tensor<640x64xf32>) -> tensor<640x64xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<640x64xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x448xf32>, tensor<448x64xf32>) outs(%arg2 : tensor<640x64xf32>) -> tensor<640x64xf32>
      NAIL.yield %m : tensor<640x64xf32>
    }
    return %r : tensor<640x64xf32>
  }
}
