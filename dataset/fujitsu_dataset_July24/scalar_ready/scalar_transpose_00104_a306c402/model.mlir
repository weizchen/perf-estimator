module {
  func.func @kernel(%arg0: tensor<26x8x31x12xi8>, %arg1: tensor<26x8x12x31xi8>) -> tensor<26x8x12x31xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<26x8x12x31xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<26x8x31x12xi8>) outs(%arg1 : tensor<26x8x12x31xi8>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<26x8x12x31xi8>
    }
    return %r : tensor<26x8x12x31xi8>
  }
}
