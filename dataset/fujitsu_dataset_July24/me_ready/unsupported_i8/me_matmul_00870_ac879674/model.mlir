module {
  func.func @kernel(%arg0: tensor<2048x1024xi8>, %arg1: tensor<1024x3712xi8>, %arg2: tensor<2048x3712xi32>) -> tensor<2048x3712xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<2048x3712xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2048x1024xi8>, tensor<1024x3712xi8>) outs(%arg2 : tensor<2048x3712xi32>) -> tensor<2048x3712xi32>
      NAIL.yield %m : tensor<2048x3712xi32>
    }
    return %r : tensor<2048x3712xi32>
  }
}
