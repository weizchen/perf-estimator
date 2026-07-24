module {
  func.func @kernel(%arg0: tensor<140x13xi8>, %arg1: tensor<13x140xi8>) -> tensor<13x140xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<13x140xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<140x13xi8>) outs(%arg1 : tensor<13x140xi8>) permutation = [1, 0]
      NAIL.yield %z : tensor<13x140xi8>
    }
    return %r : tensor<13x140xi8>
  }
}
