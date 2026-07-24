module {
  func.func @kernel(%arg0: tensor<1472x448xf32>, %arg1: tensor<448x3200xf32>, %arg2: tensor<1472x3200xf32>) -> tensor<1472x3200xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1472x3200xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1472x448xf32>, tensor<448x3200xf32>) outs(%arg2 : tensor<1472x3200xf32>) -> tensor<1472x3200xf32>
      NAIL.yield %m : tensor<1472x3200xf32>
    }
    return %r : tensor<1472x3200xf32>
  }
}
