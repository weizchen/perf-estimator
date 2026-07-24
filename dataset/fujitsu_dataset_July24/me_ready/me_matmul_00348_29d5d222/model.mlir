module {
  func.func @kernel(%arg0: tensor<3456x128xf16>, %arg1: tensor<128x3008xf16>, %arg2: tensor<3456x3008xf32>) -> tensor<3456x3008xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<3456x3008xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3456x128xf16>, tensor<128x3008xf16>) outs(%arg2 : tensor<3456x3008xf32>) -> tensor<3456x3008xf32>
      NAIL.yield %m : tensor<3456x3008xf32>
    }
    return %r : tensor<3456x3008xf32>
  }
}
