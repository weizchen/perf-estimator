module {
  func.func @kernel(%arg0: tensor<34x7x29x15xi8>, %arg1: tensor<34x29x7x15xi8>) -> tensor<34x29x7x15xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<34x29x7x15xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<34x7x29x15xi8>) outs(%arg1 : tensor<34x29x7x15xi8>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<34x29x7x15xi8>
    }
    return %r : tensor<34x29x7x15xi8>
  }
}
