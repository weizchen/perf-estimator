module {
  func.func @kernel(%arg0: tensor<26x6x123xi16>, %arg1: tensor<6x26x123xi16>) -> tensor<6x26x123xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<6x26x123xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<26x6x123xi16>) outs(%arg1 : tensor<6x26x123xi16>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<6x26x123xi16>
    }
    return %r : tensor<6x26x123xi16>
  }
}
