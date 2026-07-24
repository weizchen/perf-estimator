module {
  func.func @kernel(%arg0: tensor<18x40x20x44xf32>, %arg1: tensor<18x44x20x40xf32>) -> tensor<18x44x20x40xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<18x44x20x40xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<18x40x20x44xf32>) outs(%arg1 : tensor<18x44x20x40xf32>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<18x44x20x40xf32>
    }
    return %r : tensor<18x44x20x40xf32>
  }
}
