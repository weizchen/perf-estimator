module {
  func.func @kernel(%arg0: tensor<309xi16>, %arg1: tensor<414x309xi16>) -> tensor<414x309xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<414x309xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<309xi16>) outs(%arg1 : tensor<414x309xi16>) dimensions = [0]
      NAIL.yield %z : tensor<414x309xi16>
    }
    return %r : tensor<414x309xi16>
  }
}
