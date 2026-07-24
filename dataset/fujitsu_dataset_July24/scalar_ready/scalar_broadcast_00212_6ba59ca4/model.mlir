module {
  func.func @kernel(%arg0: tensor<119x14xf16>, %arg1: tensor<119x13x14xf16>) -> tensor<119x13x14xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<119x13x14xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<119x14xf16>) outs(%arg1 : tensor<119x13x14xf16>) dimensions = [1]
      NAIL.yield %z : tensor<119x13x14xf16>
    }
    return %r : tensor<119x13x14xf16>
  }
}
