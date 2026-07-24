module {
  func.func @kernel(%arg0: tensor<768x3200xi8>, %arg1: tensor<3200x1152xi8>, %arg2: tensor<768x1152xi32>) -> tensor<768x1152xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<768x1152xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<768x3200xi8>, tensor<3200x1152xi8>) outs(%arg2 : tensor<768x1152xi32>) -> tensor<768x1152xi32>
      NAIL.yield %m : tensor<768x1152xi32>
    }
    return %r : tensor<768x1152xi32>
  }
}
