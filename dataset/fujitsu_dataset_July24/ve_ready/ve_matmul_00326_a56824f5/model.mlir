module {
  func.func @kernel(%arg0: tensor<64x3904xbf16>, %arg1: tensor<3904x960xbf16>, %arg2: tensor<64x960xf32>) -> tensor<64x960xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<64x960xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<64x3904xbf16>, tensor<3904x960xbf16>) outs(%arg2 : tensor<64x960xf32>) -> tensor<64x960xf32>
      NAIL.yield %m : tensor<64x960xf32>
    }
    return %r : tensor<64x960xf32>
  }
}
