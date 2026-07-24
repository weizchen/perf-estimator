module {
  func.func @kernel(%arg0: tensor<25x33xi16>, %arg1: tensor<25x201x33xi16>) -> tensor<25x201x33xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<25x201x33xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<25x33xi16>) outs(%arg1 : tensor<25x201x33xi16>) dimensions = [1]
      NAIL.yield %z : tensor<25x201x33xi16>
    }
    return %r : tensor<25x201x33xi16>
  }
}
