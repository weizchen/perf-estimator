module {
  func.func @kernel(%arg0: tensor<4x19x34x9xi16>, %arg1: tensor<4x9x34x19xi16>) -> tensor<4x9x34x19xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x9x34x19xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<4x19x34x9xi16>) outs(%arg1 : tensor<4x9x34x19xi16>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<4x9x34x19xi16>
    }
    return %r : tensor<4x9x34x19xi16>
  }
}
