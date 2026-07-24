module {
  func.func @kernel(%arg0: tensor<77x26xi16>, %arg1: tensor<29x77x26xi16>) -> tensor<29x77x26xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<29x77x26xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<77x26xi16>) outs(%arg1 : tensor<29x77x26xi16>) dimensions = [0]
      NAIL.yield %z : tensor<29x77x26xi16>
    }
    return %r : tensor<29x77x26xi16>
  }
}
