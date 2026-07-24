module {
  func.func @kernel(%arg0: tensor<3456x2048xi8>, %arg1: tensor<2048x3200xi8>, %arg2: tensor<3456x3200xi32>) -> tensor<3456x3200xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<3456x3200xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3456x2048xi8>, tensor<2048x3200xi8>) outs(%arg2 : tensor<3456x3200xi32>) -> tensor<3456x3200xi32>
      NAIL.yield %m : tensor<3456x3200xi32>
    }
    return %r : tensor<3456x3200xi32>
  }
}
