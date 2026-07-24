module {
  func.func @kernel(%arg0: tensor<12x9x6x11xf16>, %arg1: tensor<12x11x6x9xf16>) -> tensor<12x11x6x9xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<12x11x6x9xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<12x9x6x11xf16>) outs(%arg1 : tensor<12x11x6x9xf16>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<12x11x6x9xf16>
    }
    return %r : tensor<12x11x6x9xf16>
  }
}
