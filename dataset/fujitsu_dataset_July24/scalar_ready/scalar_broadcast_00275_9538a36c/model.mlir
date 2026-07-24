module {
  func.func @kernel(%arg0: tensor<233x11xi16>, %arg1: tensor<233x18x11xi16>) -> tensor<233x18x11xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<233x18x11xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<233x11xi16>) outs(%arg1 : tensor<233x18x11xi16>) dimensions = [1]
      NAIL.yield %z : tensor<233x18x11xi16>
    }
    return %r : tensor<233x18x11xi16>
  }
}
