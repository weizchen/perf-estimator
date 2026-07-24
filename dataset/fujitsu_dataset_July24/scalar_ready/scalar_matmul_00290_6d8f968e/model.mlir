module {
  func.func @kernel(%arg0: tensor<1024x320xf16>, %arg1: tensor<320x64xf16>, %arg2: tensor<1024x64xf16>) -> tensor<1024x64xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1024x64xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1024x320xf16>, tensor<320x64xf16>) outs(%arg2 : tensor<1024x64xf16>) -> tensor<1024x64xf16>
      NAIL.yield %m : tensor<1024x64xf16>
    }
    return %r : tensor<1024x64xf16>
  }
}
