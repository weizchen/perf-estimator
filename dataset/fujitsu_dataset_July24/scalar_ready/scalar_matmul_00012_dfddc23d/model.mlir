module {
  func.func @kernel(%arg0: tensor<2816x2048xi8>, %arg1: tensor<2048x1664xi8>, %arg2: tensor<2816x1664xi32>) -> tensor<2816x1664xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<2816x1664xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2816x2048xi8>, tensor<2048x1664xi8>) outs(%arg2 : tensor<2816x1664xi32>) -> tensor<2816x1664xi32>
      NAIL.yield %m : tensor<2816x1664xi32>
    }
    return %r : tensor<2816x1664xi32>
  }
}
