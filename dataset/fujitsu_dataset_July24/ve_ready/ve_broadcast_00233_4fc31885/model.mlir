module {
  func.func @kernel(%arg0: tensor<356x7xi16>, %arg1: tensor<356x9x7xi16>) -> tensor<356x9x7xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<356x9x7xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<356x7xi16>) outs(%arg1 : tensor<356x9x7xi16>) dimensions = [1]
      NAIL.yield %z : tensor<356x9x7xi16>
    }
    return %r : tensor<356x9x7xi16>
  }
}
