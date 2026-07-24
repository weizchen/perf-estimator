module {
  func.func @kernel(%arg0: tensor<11x8x24x36xf32>, %arg1: tensor<11x24x8x36xf32>) -> tensor<11x24x8x36xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<11x24x8x36xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<11x8x24x36xf32>) outs(%arg1 : tensor<11x24x8x36xf32>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<11x24x8x36xf32>
    }
    return %r : tensor<11x24x8x36xf32>
  }
}
