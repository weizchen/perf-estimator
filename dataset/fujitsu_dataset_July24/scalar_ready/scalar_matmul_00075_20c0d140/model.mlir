module {
  func.func @kernel(%arg0: tensor<2432x1152xi8>, %arg1: tensor<1152x3584xi8>, %arg2: tensor<2432x3584xi32>) -> tensor<2432x3584xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2432x3584xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2432x1152xi8>, tensor<1152x3584xi8>) outs(%arg2 : tensor<2432x3584xi32>) -> tensor<2432x3584xi32>
      NAIL.yield %m : tensor<2432x3584xi32>
    }
    return %r : tensor<2432x3584xi32>
  }
}
