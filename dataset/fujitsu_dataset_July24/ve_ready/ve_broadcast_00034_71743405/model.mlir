module {
  func.func @kernel(%arg0: tensor<56xbf16>, %arg1: tensor<56x7xbf16>) -> tensor<56x7xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<56x7xbf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<56xbf16>) outs(%arg1 : tensor<56x7xbf16>) dimensions = [1]
      NAIL.yield %z : tensor<56x7xbf16>
    }
    return %r : tensor<56x7xbf16>
  }
}
