module {
  func.func @kernel(%arg0: tensor<4x34x127xbf16>, %arg1: tensor<127x34x4xbf16>) -> tensor<127x34x4xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<127x34x4xbf16> {
    %z = linalg.transpose ins(%arg0 : tensor<4x34x127xbf16>) outs(%arg1 : tensor<127x34x4xbf16>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<127x34x4xbf16>
    }
    return %r : tensor<127x34x4xbf16>
  }
}
