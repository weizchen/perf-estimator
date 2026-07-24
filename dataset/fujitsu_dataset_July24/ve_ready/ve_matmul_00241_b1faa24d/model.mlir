module {
  func.func @kernel(%arg0: tensor<3840x64xf16>, %arg1: tensor<64x576xf16>, %arg2: tensor<3840x576xf16>) -> tensor<3840x576xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3840x576xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3840x64xf16>, tensor<64x576xf16>) outs(%arg2 : tensor<3840x576xf16>) -> tensor<3840x576xf16>
      NAIL.yield %m : tensor<3840x576xf16>
    }
    return %r : tensor<3840x576xf16>
  }
}
