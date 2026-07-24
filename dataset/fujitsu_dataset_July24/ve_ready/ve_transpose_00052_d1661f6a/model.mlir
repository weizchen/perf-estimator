module {
  func.func @kernel(%arg0: tensor<11x5x27xf16>, %arg1: tensor<5x11x27xf16>) -> tensor<5x11x27xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<5x11x27xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<11x5x27xf16>) outs(%arg1 : tensor<5x11x27xf16>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<5x11x27xf16>
    }
    return %r : tensor<5x11x27xf16>
  }
}
