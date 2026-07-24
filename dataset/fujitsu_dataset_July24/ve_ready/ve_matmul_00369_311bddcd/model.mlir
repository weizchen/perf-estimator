module {
  func.func @kernel(%arg0: tensor<1088x128xbf16>, %arg1: tensor<128x2880xbf16>, %arg2: tensor<1088x2880xf32>) -> tensor<1088x2880xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1088x2880xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1088x128xbf16>, tensor<128x2880xbf16>) outs(%arg2 : tensor<1088x2880xf32>) -> tensor<1088x2880xf32>
      NAIL.yield %m : tensor<1088x2880xf32>
    }
    return %r : tensor<1088x2880xf32>
  }
}
