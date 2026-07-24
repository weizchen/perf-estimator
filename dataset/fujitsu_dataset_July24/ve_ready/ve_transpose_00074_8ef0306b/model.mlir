module {
  func.func @kernel(%arg0: tensor<29x4x19x5xbf16>, %arg1: tensor<29x4x5x19xbf16>) -> tensor<29x4x5x19xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<29x4x5x19xbf16> {
    %z = linalg.transpose ins(%arg0 : tensor<29x4x19x5xbf16>) outs(%arg1 : tensor<29x4x5x19xbf16>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<29x4x5x19xbf16>
    }
    return %r : tensor<29x4x5x19xbf16>
  }
}
