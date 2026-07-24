module {
  func.func @kernel(%arg0: tensor<26x39xi16>, %arg1: tensor<26x39xi16>, %arg2: tensor<26x39xi16>) -> tensor<26x39xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<26x39xi16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<max_signed> ins(%arg0, %arg1 : tensor<26x39xi16>, tensor<26x39xi16>) outs(%arg2 : tensor<26x39xi16>) -> tensor<26x39xi16>
      NAIL.yield %z : tensor<26x39xi16>
    }
    return %r : tensor<26x39xi16>
  }
}
