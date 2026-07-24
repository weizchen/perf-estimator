module {
  func.func @kernel(%arg0: tensor<12xi16>, %arg1: tensor<12x137xi16>) -> tensor<12x137xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<12x137xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<12xi16>) outs(%arg1 : tensor<12x137xi16>) dimensions = [1]
      NAIL.yield %z : tensor<12x137xi16>
    }
    return %r : tensor<12x137xi16>
  }
}
