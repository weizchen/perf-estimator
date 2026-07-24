module {
  func.func @kernel(%arg0: tensor<203x22xf32>, %arg1: tensor<22x203xf32>) -> tensor<22x203xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<22x203xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<203x22xf32>) outs(%arg1 : tensor<22x203xf32>) permutation = [1, 0]
      NAIL.yield %z : tensor<22x203xf32>
    }
    return %r : tensor<22x203xf32>
  }
}
