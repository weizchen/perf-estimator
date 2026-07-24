module {
  func.func @kernel(%arg0: tensor<70x84xi16>, %arg1: tensor<22x70x84xi16>) -> tensor<22x70x84xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<22x70x84xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<70x84xi16>) outs(%arg1 : tensor<22x70x84xi16>) dimensions = [0]
      NAIL.yield %z : tensor<22x70x84xi16>
    }
    return %r : tensor<22x70x84xi16>
  }
}
