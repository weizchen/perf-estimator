module {
  func.func @kernel(%arg0: tensor<1152x384xbf16>, %arg1: tensor<384x1600xbf16>, %arg2: tensor<1152x1600xf32>) -> tensor<1152x1600xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<1152x1600xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1152x384xbf16>, tensor<384x1600xbf16>) outs(%arg2 : tensor<1152x1600xf32>) -> tensor<1152x1600xf32>
      NAIL.yield %m : tensor<1152x1600xf32>
    }
    return %r : tensor<1152x1600xf32>
  }
}
