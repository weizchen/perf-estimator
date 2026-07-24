module {
  func.func @kernel(%arg0: tensor<8x67xf32>, %arg1: tensor<67x8xf32>) -> tensor<67x8xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<67x8xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<8x67xf32>) outs(%arg1 : tensor<67x8xf32>) permutation = [1, 0]
      NAIL.yield %z : tensor<67x8xf32>
    }
    return %r : tensor<67x8xf32>
  }
}
