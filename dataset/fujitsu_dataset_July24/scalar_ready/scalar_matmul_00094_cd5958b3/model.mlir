module {
  func.func @kernel(%arg0: tensor<3968x1920xi8>, %arg1: tensor<1920x896xi8>, %arg2: tensor<3968x896xi32>) -> tensor<3968x896xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<3968x896xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3968x1920xi8>, tensor<1920x896xi8>) outs(%arg2 : tensor<3968x896xi32>) -> tensor<3968x896xi32>
      NAIL.yield %m : tensor<3968x896xi32>
    }
    return %r : tensor<3968x896xi32>
  }
}
