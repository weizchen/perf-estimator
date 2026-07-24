module {
  func.func @kernel(%arg0: tensor<17x58xf32>, %arg1: tensor<58x17xf32>) -> tensor<58x17xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<58x17xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<17x58xf32>) outs(%arg1 : tensor<58x17xf32>) permutation = [1, 0]
      NAIL.yield %z : tensor<58x17xf32>
    }
    return %r : tensor<58x17xf32>
  }
}
