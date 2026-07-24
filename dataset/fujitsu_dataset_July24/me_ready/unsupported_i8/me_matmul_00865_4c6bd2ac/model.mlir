module {
  func.func @kernel(%arg0: tensor<1408x896xi8>, %arg1: tensor<896x896xi8>, %arg2: tensor<1408x896xi32>) -> tensor<1408x896xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1408x896xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1408x896xi8>, tensor<896x896xi8>) outs(%arg2 : tensor<1408x896xi32>) -> tensor<1408x896xi32>
      NAIL.yield %m : tensor<1408x896xi32>
    }
    return %r : tensor<1408x896xi32>
  }
}
