module {
  func.func @kernel(%arg0: tensor<19x35x15x40xf16>, %arg1: tensor<19x15x35x40xf16>) -> tensor<19x15x35x40xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<19x15x35x40xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<19x35x15x40xf16>) outs(%arg1 : tensor<19x15x35x40xf16>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<19x15x35x40xf16>
    }
    return %r : tensor<19x15x35x40xf16>
  }
}
