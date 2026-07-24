module {
  func.func @kernel(%arg0: tensor<1088x1216xf16>, %arg1: tensor<1216x1024xf16>, %arg2: tensor<1088x1024xf32>) -> tensor<1088x1024xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1088x1024xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1088x1216xf16>, tensor<1216x1024xf16>) outs(%arg2 : tensor<1088x1024xf32>) -> tensor<1088x1024xf32>
      NAIL.yield %m : tensor<1088x1024xf32>
    }
    return %r : tensor<1088x1024xf32>
  }
}
