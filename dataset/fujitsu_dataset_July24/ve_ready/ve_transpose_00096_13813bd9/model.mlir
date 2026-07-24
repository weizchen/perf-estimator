module {
  func.func @kernel(%arg0: tensor<37x41x29x8xi16>, %arg1: tensor<37x29x41x8xi16>) -> tensor<37x29x41x8xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<37x29x41x8xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<37x41x29x8xi16>) outs(%arg1 : tensor<37x29x41x8xi16>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<37x29x41x8xi16>
    }
    return %r : tensor<37x29x41x8xi16>
  }
}
