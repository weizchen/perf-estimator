module {
  func.func @kernel(%arg0: tensor<26x29xi1>, %arg1: tensor<26x29xi16>, %arg2: tensor<26x29xi16>, %arg3: tensor<26x29xi16>) -> tensor<26x29xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<26x29xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<26x29xi1>, tensor<26x29xi16>, tensor<26x29xi16>) outs(%arg3 : tensor<26x29xi16>) -> tensor<26x29xi16>
      NAIL.yield %z : tensor<26x29xi16>
    }
    return %r : tensor<26x29xi16>
  }
}
