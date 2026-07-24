module {
  func.func @kernel(%arg0: tensor<19x39x126xi8>, %arg1: tensor<39x19x126xi8>) -> tensor<39x19x126xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<39x19x126xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<19x39x126xi8>) outs(%arg1 : tensor<39x19x126xi8>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<39x19x126xi8>
    }
    return %r : tensor<39x19x126xi8>
  }
}
