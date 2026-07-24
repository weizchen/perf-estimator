module {
  func.func @kernel(%arg0: tensor<238x67xi8>, %arg1: tensor<67x238xi8>) -> tensor<67x238xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<67x238xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<238x67xi8>) outs(%arg1 : tensor<67x238xi8>) permutation = [1, 0]
      NAIL.yield %z : tensor<67x238xi8>
    }
    return %r : tensor<67x238xi8>
  }
}
