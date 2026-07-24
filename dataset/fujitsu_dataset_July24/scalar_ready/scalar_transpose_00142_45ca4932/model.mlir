module {
  func.func @kernel(%arg0: tensor<126x173xf16>, %arg1: tensor<173x126xf16>) -> tensor<173x126xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<173x126xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<126x173xf16>) outs(%arg1 : tensor<173x126xf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<173x126xf16>
    }
    return %r : tensor<173x126xf16>
  }
}
