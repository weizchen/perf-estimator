module {
  func.func @kernel(%arg0: tensor<22x16xi16>, %arg1: tensor<22x16x22xi16>) -> tensor<22x16x22xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<22x16x22xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<22x16xi16>) outs(%arg1 : tensor<22x16x22xi16>) dimensions = [2]
      NAIL.yield %z : tensor<22x16x22xi16>
    }
    return %r : tensor<22x16x22xi16>
  }
}
