module {
  func.func @kernel(%arg0: tensor<26x11x7x14xf16>, %arg1: tensor<26x11x14x7xf16>) -> tensor<26x11x14x7xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<26x11x14x7xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<26x11x7x14xf16>) outs(%arg1 : tensor<26x11x14x7xf16>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<26x11x14x7xf16>
    }
    return %r : tensor<26x11x14x7xf16>
  }
}
