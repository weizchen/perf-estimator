module {
  func.func @kernel(%arg0: tensor<1024x3072xf8E5M2>, %arg1: tensor<3072x3712xf8E5M2>, %arg2: tensor<1024x3712xf32>) -> tensor<1024x3712xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1024x3712xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1024x3072xf8E5M2>, tensor<3072x3712xf8E5M2>) outs(%arg2 : tensor<1024x3712xf32>) -> tensor<1024x3712xf32>
      NAIL.yield %m : tensor<1024x3712xf32>
    }
    return %r : tensor<1024x3712xf32>
  }
}
