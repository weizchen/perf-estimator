module {
  func.func @kernel(%arg0: tensor<92xi1>, %arg1: tensor<92xbf16>, %arg2: tensor<92xbf16>, %arg3: tensor<92xbf16>) -> tensor<92xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<92xbf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<92xi1>, tensor<92xbf16>, tensor<92xbf16>) outs(%arg3 : tensor<92xbf16>) -> tensor<92xbf16>
      NAIL.yield %z : tensor<92xbf16>
    }
    return %r : tensor<92xbf16>
  }
}
