module {
  func.func @kernel(%arg0: tensor<320x576xf16>, %arg1: tensor<576x64xf16>, %arg2: tensor<320x64xf16>) -> tensor<320x64xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<320x64xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<320x576xf16>, tensor<576x64xf16>) outs(%arg2 : tensor<320x64xf16>) -> tensor<320x64xf16>
      NAIL.yield %m : tensor<320x64xf16>
    }
    return %r : tensor<320x64xf16>
  }
}
