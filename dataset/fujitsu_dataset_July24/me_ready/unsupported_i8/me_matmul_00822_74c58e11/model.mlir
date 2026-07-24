module {
  func.func @kernel(%arg0: tensor<896x3968xi8>, %arg1: tensor<3968x1536xi8>, %arg2: tensor<896x1536xi32>) -> tensor<896x1536xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<896x1536xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<896x3968xi8>, tensor<3968x1536xi8>) outs(%arg2 : tensor<896x1536xi32>) -> tensor<896x1536xi32>
      NAIL.yield %m : tensor<896x1536xi32>
    }
    return %r : tensor<896x1536xi32>
  }
}
