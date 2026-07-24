module {
  func.func @kernel(%arg0: tensor<3840x2816xbf16>, %arg1: tensor<2816x960xbf16>, %arg2: tensor<3840x960xf32>) -> tensor<3840x960xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3840x960xf32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3840x2816xbf16>, tensor<2816x960xbf16>) outs(%arg2 : tensor<3840x960xf32>) -> tensor<3840x960xf32>
      NAIL.yield %m : tensor<3840x960xf32>
    }
    return %r : tensor<3840x960xf32>
  }
}
