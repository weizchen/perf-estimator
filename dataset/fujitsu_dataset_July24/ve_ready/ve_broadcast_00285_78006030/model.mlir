module {
  func.func @kernel(%arg0: tensor<27x14xbf16>, %arg1: tensor<57x27x14xbf16>) -> tensor<57x27x14xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<57x27x14xbf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<27x14xbf16>) outs(%arg1 : tensor<57x27x14xbf16>) dimensions = [0]
      NAIL.yield %z : tensor<57x27x14xbf16>
    }
    return %r : tensor<57x27x14xbf16>
  }
}
