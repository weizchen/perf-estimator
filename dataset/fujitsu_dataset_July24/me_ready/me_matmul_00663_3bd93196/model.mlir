module {
  func.func @kernel(%arg0: tensor<2304x2752xf16>, %arg1: tensor<2752x64xf16>, %arg2: tensor<2304x64xf16>) -> tensor<2304x64xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<2304x64xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<2304x2752xf16>, tensor<2752x64xf16>) outs(%arg2 : tensor<2304x64xf16>) -> tensor<2304x64xf16>
      NAIL.yield %m : tensor<2304x64xf16>
    }
    return %r : tensor<2304x64xf16>
  }
}
