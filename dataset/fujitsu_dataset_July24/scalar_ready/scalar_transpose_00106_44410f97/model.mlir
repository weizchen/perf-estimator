module {
  func.func @kernel(%arg0: tensor<23x12x21x26xf32>, %arg1: tensor<23x21x12x26xf32>) -> tensor<23x21x12x26xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<23x21x12x26xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<23x12x21x26xf32>) outs(%arg1 : tensor<23x21x12x26xf32>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<23x21x12x26xf32>
    }
    return %r : tensor<23x21x12x26xf32>
  }
}
