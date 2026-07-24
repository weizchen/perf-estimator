module {
  func.func @kernel(%arg0: tensor<11x11x24x8xbf16>, %arg1: tensor<11x24x11x8xbf16>) -> tensor<11x24x11x8xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<11x24x11x8xbf16> {
    %z = linalg.transpose ins(%arg0 : tensor<11x11x24x8xbf16>) outs(%arg1 : tensor<11x24x11x8xbf16>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<11x24x11x8xbf16>
    }
    return %r : tensor<11x24x11x8xbf16>
  }
}
