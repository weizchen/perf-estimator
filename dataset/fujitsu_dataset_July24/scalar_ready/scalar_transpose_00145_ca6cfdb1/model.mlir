module {
  func.func @kernel(%arg0: tensor<7x91xf16>, %arg1: tensor<91x7xf16>) -> tensor<91x7xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<91x7xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<7x91xf16>) outs(%arg1 : tensor<91x7xf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<91x7xf16>
    }
    return %r : tensor<91x7xf16>
  }
}
