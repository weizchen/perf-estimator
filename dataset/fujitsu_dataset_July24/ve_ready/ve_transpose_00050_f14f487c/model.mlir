module {
  func.func @kernel(%arg0: tensor<46x5x5x24xbf16>, %arg1: tensor<46x5x5x24xbf16>) -> tensor<46x5x5x24xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<46x5x5x24xbf16> {
    %z = linalg.transpose ins(%arg0 : tensor<46x5x5x24xbf16>) outs(%arg1 : tensor<46x5x5x24xbf16>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<46x5x5x24xbf16>
    }
    return %r : tensor<46x5x5x24xbf16>
  }
}
