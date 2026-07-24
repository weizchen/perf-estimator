module {
  func.func @kernel(%arg0: tensor<512x128xi8>, %arg1: tensor<128x3968xi8>, %arg2: tensor<512x3968xi32>) -> tensor<512x3968xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<512x3968xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<512x128xi8>, tensor<128x3968xi8>) outs(%arg2 : tensor<512x3968xi32>) -> tensor<512x3968xi32>
      NAIL.yield %m : tensor<512x3968xi32>
    }
    return %r : tensor<512x3968xi32>
  }
}
