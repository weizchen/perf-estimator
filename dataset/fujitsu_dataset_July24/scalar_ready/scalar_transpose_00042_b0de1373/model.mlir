module {
  func.func @kernel(%arg0: tensor<15x36xf16>, %arg1: tensor<36x15xf16>) -> tensor<36x15xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<36x15xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<15x36xf16>) outs(%arg1 : tensor<36x15xf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<36x15xf16>
    }
    return %r : tensor<36x15xf16>
  }
}
