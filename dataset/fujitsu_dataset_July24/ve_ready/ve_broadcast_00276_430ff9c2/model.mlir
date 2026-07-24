module {
  func.func @kernel(%arg0: tensor<139xi16>, %arg1: tensor<14x139xi16>) -> tensor<14x139xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<14x139xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<139xi16>) outs(%arg1 : tensor<14x139xi16>) dimensions = [0]
      NAIL.yield %z : tensor<14x139xi16>
    }
    return %r : tensor<14x139xi16>
  }
}
