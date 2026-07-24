module {
  func.func @kernel(%arg0: tensor<10x76xbf16>, %arg1: tensor<76x10xbf16>) -> tensor<76x10xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<76x10xbf16> {
    %z = linalg.transpose ins(%arg0 : tensor<10x76xbf16>) outs(%arg1 : tensor<76x10xbf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<76x10xbf16>
    }
    return %r : tensor<76x10xbf16>
  }
}
