module {
  func.func @kernel(%arg0: tensor<507x87xi1>, %arg1: tensor<507x87xbf16>, %arg2: tensor<507x87xbf16>, %arg3: tensor<507x87xbf16>) -> tensor<507x87xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<507x87xbf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<507x87xi1>, tensor<507x87xbf16>, tensor<507x87xbf16>) outs(%arg3 : tensor<507x87xbf16>) -> tensor<507x87xbf16>
      NAIL.yield %z : tensor<507x87xbf16>
    }
    return %r : tensor<507x87xbf16>
  }
}
