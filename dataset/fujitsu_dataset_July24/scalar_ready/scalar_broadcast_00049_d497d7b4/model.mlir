module {
  func.func @kernel(%arg0: tensor<27x16xf16>, %arg1: tensor<27x57x16xf16>) -> tensor<27x57x16xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<27x57x16xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<27x16xf16>) outs(%arg1 : tensor<27x57x16xf16>) dimensions = [1]
      NAIL.yield %z : tensor<27x57x16xf16>
    }
    return %r : tensor<27x57x16xf16>
  }
}
