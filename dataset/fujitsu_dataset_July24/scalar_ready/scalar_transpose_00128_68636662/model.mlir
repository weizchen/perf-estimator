module {
  func.func @kernel(%arg0: tensor<12x19x14x43xf32>, %arg1: tensor<12x43x14x19xf32>) -> tensor<12x43x14x19xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<12x43x14x19xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<12x19x14x43xf32>) outs(%arg1 : tensor<12x43x14x19xf32>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<12x43x14x19xf32>
    }
    return %r : tensor<12x43x14x19xf32>
  }
}
