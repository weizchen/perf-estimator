module {
  func.func @kernel(%arg0: tensor<18x59xf16>, %arg1: tensor<18x32x59xf16>) -> tensor<18x32x59xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<18x32x59xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<18x59xf16>) outs(%arg1 : tensor<18x32x59xf16>) dimensions = [1]
      NAIL.yield %z : tensor<18x32x59xf16>
    }
    return %r : tensor<18x32x59xf16>
  }
}
