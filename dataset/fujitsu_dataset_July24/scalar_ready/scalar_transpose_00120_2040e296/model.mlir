module {
  func.func @kernel(%arg0: tensor<4x34x127xf16>, %arg1: tensor<127x34x4xf16>) -> tensor<127x34x4xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<127x34x4xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<4x34x127xf16>) outs(%arg1 : tensor<127x34x4xf16>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<127x34x4xf16>
    }
    return %r : tensor<127x34x4xf16>
  }
}
