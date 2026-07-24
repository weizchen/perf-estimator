module {
  func.func @kernel(%arg0: tensor<1280x896xbf16>, %arg1: tensor<896x2944xbf16>, %arg2: tensor<1280x2944xf16>) -> tensor<1280x2944xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<1280x2944xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<1280x896xbf16>, tensor<896x2944xbf16>) outs(%arg2 : tensor<1280x2944xf16>) -> tensor<1280x2944xf16>
      NAIL.yield %m : tensor<1280x2944xf16>
    }
    return %r : tensor<1280x2944xf16>
  }
}
