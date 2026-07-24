module {
  func.func @kernel(%arg0: tensor<95x210xi8>, %arg1: tensor<210x95xi8>) -> tensor<210x95xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<210x95xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<95x210xi8>) outs(%arg1 : tensor<210x95xi8>) permutation = [1, 0]
      NAIL.yield %z : tensor<210x95xi8>
    }
    return %r : tensor<210x95xi8>
  }
}
