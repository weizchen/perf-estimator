module {
  func.func @kernel(%arg0: tensor<128x3136xbf16>, %arg1: tensor<3136x256xbf16>, %arg2: tensor<128x256xf16>) -> tensor<128x256xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 2> -> tensor<128x256xf16> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<128x3136xbf16>, tensor<3136x256xbf16>) outs(%arg2 : tensor<128x256xf16>) -> tensor<128x256xf16>
      NAIL.yield %m : tensor<128x256xf16>
    }
    return %r : tensor<128x256xf16>
  }
}
