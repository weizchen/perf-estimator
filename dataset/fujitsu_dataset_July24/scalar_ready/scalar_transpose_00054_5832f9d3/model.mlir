module {
  func.func @kernel(%arg0: tensor<51x88x96xf32>, %arg1: tensor<96x88x51xf32>) -> tensor<96x88x51xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<96x88x51xf32> {
    %z = linalg.transpose ins(%arg0 : tensor<51x88x96xf32>) outs(%arg1 : tensor<96x88x51xf32>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<96x88x51xf32>
    }
    return %r : tensor<96x88x51xf32>
  }
}
