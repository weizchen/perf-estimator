module {
  func.func @kernel(%arg0: tensor<19x11x14x21xf32>, %arg1: tensor<19x11x21x14xf32>) -> tensor<19x11x21x14xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<19x11x21x14xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<19x11x14x21xf32>) outs(%arg1 : tensor<19x11x21x14xf32>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<19x11x21x14xf32>
    }
    return %r : tensor<19x11x21x14xf32>
  }
}
