module {
  func.func @kernel(%arg0: tensor<12x5x27x4xi16>, %arg1: tensor<12x4x27x5xi16>) -> tensor<12x4x27x5xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<12x4x27x5xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<12x5x27x4xi16>) outs(%arg1 : tensor<12x4x27x5xi16>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<12x4x27x5xi16>
    }
    return %r : tensor<12x4x27x5xi16>
  }
}
