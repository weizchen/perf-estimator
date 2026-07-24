module {
  func.func @kernel(%arg0: tensor<19x11x14x21xf16>, %arg1: tensor<19x11x21x14xf16>) -> tensor<19x11x21x14xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<19x11x21x14xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<19x11x14x21xf16>) outs(%arg1 : tensor<19x11x21x14xf16>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<19x11x21x14xf16>
    }
    return %r : tensor<19x11x21x14xf16>
  }
}
