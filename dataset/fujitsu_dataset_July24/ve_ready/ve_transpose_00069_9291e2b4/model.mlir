module {
  func.func @kernel(%arg0: tensor<37x13x16x21xf32>, %arg1: tensor<37x21x16x13xf32>) -> tensor<37x21x16x13xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<37x21x16x13xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<37x13x16x21xf32>) outs(%arg1 : tensor<37x21x16x13xf32>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<37x21x16x13xf32>
    }
    return %r : tensor<37x21x16x13xf32>
  }
}
