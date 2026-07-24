module {
  func.func @kernel(%arg0: tensor<85x4x9xf32>, %arg1: tensor<9x4x85xf32>) -> tensor<9x4x85xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<9x4x85xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<85x4x9xf32>) outs(%arg1 : tensor<9x4x85xf32>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<9x4x85xf32>
    }
    return %r : tensor<9x4x85xf32>
  }
}
