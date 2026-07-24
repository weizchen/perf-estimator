module {
  func.func @kernel(%arg0: tensor<7xi1>, %arg1: tensor<7xbf16>, %arg2: tensor<7xbf16>, %arg3: tensor<7xbf16>) -> tensor<7xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<7xbf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<7xi1>, tensor<7xbf16>, tensor<7xbf16>) outs(%arg3 : tensor<7xbf16>) -> tensor<7xbf16>
      NAIL.yield %z : tensor<7xbf16>
    }
    return %r : tensor<7xbf16>
  }
}
