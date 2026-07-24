module {
  func.func @kernel(%arg0: tensor<128x704xbf16>, %arg1: tensor<704x64xbf16>, %arg2: tensor<128x64xf16>) -> tensor<128x64xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<128x64xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x704xbf16>, tensor<704x64xbf16>) outs(%arg2 : tensor<128x64xf16>) -> tensor<128x64xf16>
      NAIL.yield %m : tensor<128x64xf16>
    }
    return %r : tensor<128x64xf16>
  }
}
