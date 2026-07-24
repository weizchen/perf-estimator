module {
  func.func @kernel(%arg0: tensor<26x97xi1>, %arg1: tensor<26x97xf16>, %arg2: tensor<26x97xf16>, %arg3: tensor<26x97xf16>) -> tensor<26x97xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<26x97xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<26x97xi1>, tensor<26x97xf16>, tensor<26x97xf16>) outs(%arg3 : tensor<26x97xf16>) -> tensor<26x97xf16>
      NAIL.yield %z : tensor<26x97xf16>
    }
    return %r : tensor<26x97xf16>
  }
}
