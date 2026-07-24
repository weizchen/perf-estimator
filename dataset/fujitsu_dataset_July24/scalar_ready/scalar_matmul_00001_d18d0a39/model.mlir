module {
  func.func @kernel(%arg0: tensor<128x2304xi8>, %arg1: tensor<2304x1664xi8>, %arg2: tensor<128x1664xi32>) -> tensor<128x1664xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<128x1664xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x2304xi8>, tensor<2304x1664xi8>) outs(%arg2 : tensor<128x1664xi32>) -> tensor<128x1664xi32>
      NAIL.yield %m : tensor<128x1664xi32>
    }
    return %r : tensor<128x1664xi32>
  }
}
