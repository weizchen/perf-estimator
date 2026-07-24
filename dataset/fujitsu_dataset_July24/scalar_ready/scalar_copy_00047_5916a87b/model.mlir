module {
  func.func @kernel(%arg0: tensor<130x20xf16>, %arg1: tensor<130x20xf16>) -> tensor<130x20xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<130x20xf16> {
    %z = linalg.copy ins(%arg0 : tensor<130x20xf16>) outs(%arg1 : tensor<130x20xf16>) -> tensor<130x20xf16>
      NAIL.yield %z : tensor<130x20xf16>
    }
    return %r : tensor<130x20xf16>
  }
}
