module {
  func.func @kernel(%arg0: tensor<256x3200xf16>, %arg1: tensor<3200x960xf16>, %arg2: tensor<256x960xf16>) -> tensor<256x960xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<256x960xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<256x3200xf16>, tensor<3200x960xf16>) outs(%arg2 : tensor<256x960xf16>) -> tensor<256x960xf16>
      NAIL.yield %m : tensor<256x960xf16>
    }
    return %r : tensor<256x960xf16>
  }
}
