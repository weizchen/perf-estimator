module {
  func.func @kernel(%arg0: tensor<3264x64xbf16>, %arg1: tensor<64x960xbf16>, %arg2: tensor<3264x960xf32>) -> tensor<3264x960xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<3264x960xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3264x64xbf16>, tensor<64x960xbf16>) outs(%arg2 : tensor<3264x960xf32>) -> tensor<3264x960xf32>
      NAIL.yield %m : tensor<3264x960xf32>
    }
    return %r : tensor<3264x960xf32>
  }
}
