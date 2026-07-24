module {
  func.func @kernel(%arg0: tensor<33x158xi1>, %arg1: tensor<33x158xbf16>, %arg2: tensor<33x158xbf16>, %arg3: tensor<33x158xbf16>) -> tensor<33x158xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<33x158xbf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<33x158xi1>, tensor<33x158xbf16>, tensor<33x158xbf16>) outs(%arg3 : tensor<33x158xbf16>) -> tensor<33x158xbf16>
      NAIL.yield %z : tensor<33x158xbf16>
    }
    return %r : tensor<33x158xbf16>
  }
}
