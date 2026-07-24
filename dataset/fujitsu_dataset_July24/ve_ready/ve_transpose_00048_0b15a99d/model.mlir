module {
  func.func @kernel(%arg0: tensor<12x61x48xf32>, %arg1: tensor<61x12x48xf32>) -> tensor<61x12x48xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<61x12x48xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<12x61x48xf32>) outs(%arg1 : tensor<61x12x48xf32>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<61x12x48xf32>
    }
    return %r : tensor<61x12x48xf32>
  }
}
