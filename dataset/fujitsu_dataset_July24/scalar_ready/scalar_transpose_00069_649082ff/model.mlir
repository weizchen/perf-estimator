module {
  func.func @kernel(%arg0: tensor<37x6x15x17xf32>, %arg1: tensor<37x6x17x15xf32>) -> tensor<37x6x17x15xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<37x6x17x15xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<37x6x15x17xf32>) outs(%arg1 : tensor<37x6x17x15xf32>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<37x6x17x15xf32>
    }
    return %r : tensor<37x6x17x15xf32>
  }
}
