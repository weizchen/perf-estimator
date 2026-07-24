module {
  func.func @kernel(%arg0: tensor<159x61xi1>, %arg1: tensor<159x61xbf16>, %arg2: tensor<159x61xbf16>, %arg3: tensor<159x61xbf16>) -> tensor<159x61xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<159x61xbf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<159x61xi1>, tensor<159x61xbf16>, tensor<159x61xbf16>) outs(%arg3 : tensor<159x61xbf16>) -> tensor<159x61xbf16>
      NAIL.yield %z : tensor<159x61xbf16>
    }
    return %r : tensor<159x61xbf16>
  }
}
