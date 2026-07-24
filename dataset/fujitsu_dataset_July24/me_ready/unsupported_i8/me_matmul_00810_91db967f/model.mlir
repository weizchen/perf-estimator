module {
  func.func @kernel(%arg0: tensor<640x128xi8>, %arg1: tensor<128x512xi8>, %arg2: tensor<640x512xi32>) -> tensor<640x512xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<640x512xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<640x128xi8>, tensor<128x512xi8>) outs(%arg2 : tensor<640x512xi32>) -> tensor<640x512xi32>
      NAIL.yield %m : tensor<640x512xi32>
    }
    return %r : tensor<640x512xi32>
  }
}
