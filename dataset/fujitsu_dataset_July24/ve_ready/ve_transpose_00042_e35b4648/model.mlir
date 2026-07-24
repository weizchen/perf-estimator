module {
  func.func @kernel(%arg0: tensor<15x36xbf16>, %arg1: tensor<36x15xbf16>) -> tensor<36x15xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<36x15xbf16> {
    %z = linalg.transpose ins(%arg0 : tensor<15x36xbf16>) outs(%arg1 : tensor<36x15xbf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<36x15xbf16>
    }
    return %r : tensor<36x15xbf16>
  }
}
