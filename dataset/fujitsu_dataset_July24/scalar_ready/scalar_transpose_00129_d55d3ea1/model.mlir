module {
  func.func @kernel(%arg0: tensor<13x23x6x7xi8>, %arg1: tensor<13x6x23x7xi8>) -> tensor<13x6x23x7xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<13x6x23x7xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<13x23x6x7xi8>) outs(%arg1 : tensor<13x6x23x7xi8>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<13x6x23x7xi8>
    }
    return %r : tensor<13x6x23x7xi8>
  }
}
