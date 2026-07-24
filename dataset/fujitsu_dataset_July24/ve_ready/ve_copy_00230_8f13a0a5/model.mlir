module {
  func.func @kernel(%arg0: tensor<7x168x5xbf16>, %arg1: tensor<7x168x5xbf16>) -> tensor<7x168x5xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<7x168x5xbf16> {
    %z = linalg.copy ins(%arg0 : tensor<7x168x5xbf16>) outs(%arg1 : tensor<7x168x5xbf16>) -> tensor<7x168x5xbf16>
      NAIL.yield %z : tensor<7x168x5xbf16>
    }
    return %r : tensor<7x168x5xbf16>
  }
}
