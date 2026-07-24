module {
  func.func @kernel(%arg0: tensor<37x13x16x21xi8>, %arg1: tensor<37x21x16x13xi8>) -> tensor<37x21x16x13xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<37x21x16x13xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<37x13x16x21xi8>) outs(%arg1 : tensor<37x21x16x13xi8>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<37x21x16x13xi8>
    }
    return %r : tensor<37x21x16x13xi8>
  }
}
