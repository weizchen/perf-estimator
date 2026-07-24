module {
  func.func @kernel(%arg0: tensor<7x71x8xi8>, %arg1: tensor<71x7x8xi8>) -> tensor<71x7x8xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<71x7x8xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<7x71x8xi8>) outs(%arg1 : tensor<71x7x8xi8>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<71x7x8xi8>
    }
    return %r : tensor<71x7x8xi8>
  }
}
