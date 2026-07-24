module {
  func.func @kernel(%arg0: tensor<128x1152xf8E5M2>, %arg1: tensor<1152x1024xf8E5M2>, %arg2: tensor<128x1024xf32>) -> tensor<128x1024xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<128x1024xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x1152xf8E5M2>, tensor<1152x1024xf8E5M2>) outs(%arg2 : tensor<128x1024xf32>) -> tensor<128x1024xf32>
      NAIL.yield %m : tensor<128x1024xf32>
    }
    return %r : tensor<128x1024xf32>
  }
}
