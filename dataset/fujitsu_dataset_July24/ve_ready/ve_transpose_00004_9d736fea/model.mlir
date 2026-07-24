module {
  func.func @kernel(%arg0: tensor<22x18xf32>, %arg1: tensor<18x22xf32>) -> tensor<18x22xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<18x22xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<22x18xf32>) outs(%arg1 : tensor<18x22xf32>) permutation = [1, 0]
      NAIL.yield %z : tensor<18x22xf32>
    }
    return %r : tensor<18x22xf32>
  }
}
