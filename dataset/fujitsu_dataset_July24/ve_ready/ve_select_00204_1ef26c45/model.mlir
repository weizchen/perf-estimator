module {
  func.func @kernel(%arg0: tensor<15x32xi1>, %arg1: tensor<15x32xbf16>, %arg2: tensor<15x32xbf16>, %arg3: tensor<15x32xbf16>) -> tensor<15x32xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<15x32xbf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<15x32xi1>, tensor<15x32xbf16>, tensor<15x32xbf16>) outs(%arg3 : tensor<15x32xbf16>) -> tensor<15x32xbf16>
      NAIL.yield %z : tensor<15x32xbf16>
    }
    return %r : tensor<15x32xbf16>
  }
}
