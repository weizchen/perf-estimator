module {
  func.func @kernel(%arg0: tensor<12x25x9x34xi16>, %arg1: tensor<12x34x9x25xi16>) -> tensor<12x34x9x25xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<12x34x9x25xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<12x25x9x34xi16>) outs(%arg1 : tensor<12x34x9x25xi16>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<12x34x9x25xi16>
    }
    return %r : tensor<12x34x9x25xi16>
  }
}
