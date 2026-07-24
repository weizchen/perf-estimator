module {
  func.func @kernel(%arg0: tensor<32x14x14x7xf32>, %arg1: tensor<32x14x14x7xf32>) -> tensor<32x14x14x7xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<32x14x14x7xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<32x14x14x7xf32>) outs(%arg1 : tensor<32x14x14x7xf32>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<32x14x14x7xf32>
    }
    return %r : tensor<32x14x14x7xf32>
  }
}
