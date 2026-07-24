module {
  func.func @kernel(%arg0: tensor<287x77xf16>, %arg1: tensor<77x287xf16>) -> tensor<77x287xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<77x287xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<287x77xf16>) outs(%arg1 : tensor<77x287xf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<77x287xf16>
    }
    return %r : tensor<77x287xf16>
  }
}
