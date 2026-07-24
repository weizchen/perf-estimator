module {
  func.func @kernel(%arg0: tensor<77x26xi8>, %arg1: tensor<26x77xi8>) -> tensor<26x77xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<26x77xi8> {
    %z = linalg.transpose ins(%arg0 : tensor<77x26xi8>) outs(%arg1 : tensor<26x77xi8>) permutation = [1, 0]
      NAIL.yield %z : tensor<26x77xi8>
    }
    return %r : tensor<26x77xi8>
  }
}
