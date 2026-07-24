module {
  func.func @kernel(%arg0: tensor<15x16x38xf32>, %arg1: tensor<15x38x16xf32>) -> tensor<15x38x16xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<15x38x16xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<15x16x38xf32>) outs(%arg1 : tensor<15x38x16xf32>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<15x38x16xf32>
    }
    return %r : tensor<15x38x16xf32>
  }
}
