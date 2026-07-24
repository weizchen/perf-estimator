module {
  func.func @kernel(%arg0: tensor<23x21x35x4xf32>, %arg1: tensor<23x4x35x21xf32>) -> tensor<23x4x35x21xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<23x4x35x21xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<23x21x35x4xf32>) outs(%arg1 : tensor<23x4x35x21xf32>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<23x4x35x21xf32>
    }
    return %r : tensor<23x4x35x21xf32>
  }
}
