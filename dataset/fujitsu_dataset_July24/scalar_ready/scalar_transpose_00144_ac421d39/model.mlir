module {
  func.func @kernel(%arg0: tensor<7x8x24x20xf32>, %arg1: tensor<7x20x24x8xf32>) -> tensor<7x20x24x8xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<7x20x24x8xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<7x8x24x20xf32>) outs(%arg1 : tensor<7x20x24x8xf32>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<7x20x24x8xf32>
    }
    return %r : tensor<7x20x24x8xf32>
  }
}
