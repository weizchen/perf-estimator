module {
  func.func @kernel(%arg0: tensor<102x6x19xi8>, %arg1: tensor<19x6x102xi8>) -> tensor<19x6x102xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<19x6x102xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<102x6x19xi8>) outs(%arg1 : tensor<19x6x102xi8>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<19x6x102xi8>
    }
    return %r : tensor<19x6x102xi8>
  }
}
