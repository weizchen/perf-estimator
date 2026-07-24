module {
  func.func @kernel(%arg0: tensor<128x3456xi8>, %arg1: tensor<3456x768xi8>, %arg2: tensor<128x768xi32>) -> tensor<128x768xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<128x768xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x3456xi8>, tensor<3456x768xi8>) outs(%arg2 : tensor<128x768xi32>) -> tensor<128x768xi32>
      NAIL.yield %m : tensor<128x768xi32>
    }
    return %r : tensor<128x768xi32>
  }
}
