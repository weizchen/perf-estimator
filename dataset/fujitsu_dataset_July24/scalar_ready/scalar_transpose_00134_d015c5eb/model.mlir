module {
  func.func @kernel(%arg0: tensor<7x8x41xf16>, %arg1: tensor<41x8x7xf16>) -> tensor<41x8x7xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<41x8x7xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<7x8x41xf16>) outs(%arg1 : tensor<41x8x7xf16>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<41x8x7xf16>
    }
    return %r : tensor<41x8x7xf16>
  }
}
