module {
  func.func @kernel(%arg0: tensor<2304x896xi8>, %arg1: tensor<896x1152xi8>, %arg2: tensor<2304x1152xi32>) -> tensor<2304x1152xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2304x1152xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2304x896xi8>, tensor<896x1152xi8>) outs(%arg2 : tensor<2304x1152xi32>) -> tensor<2304x1152xi32>
      NAIL.yield %m : tensor<2304x1152xi32>
    }
    return %r : tensor<2304x1152xi32>
  }
}
