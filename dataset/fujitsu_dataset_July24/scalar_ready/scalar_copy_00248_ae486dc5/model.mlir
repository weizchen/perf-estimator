module {
  func.func @kernel(%arg0: tensor<84xf16>, %arg1: tensor<84xf16>) -> tensor<84xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<84xf16> {
    %z = linalg.copy ins(%arg0 : tensor<84xf16>) outs(%arg1 : tensor<84xf16>) -> tensor<84xf16>
      NAIL.yield %z : tensor<84xf16>
    }
    return %r : tensor<84xf16>
  }
}
