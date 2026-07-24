module {
  func.func @kernel(%arg0: tensor<4x6x47x17xf32>, %arg1: tensor<4x47x6x17xf32>) -> tensor<4x47x6x17xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<4x47x6x17xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<4x6x47x17xf32>) outs(%arg1 : tensor<4x47x6x17xf32>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<4x47x6x17xf32>
    }
    return %r : tensor<4x47x6x17xf32>
  }
}
