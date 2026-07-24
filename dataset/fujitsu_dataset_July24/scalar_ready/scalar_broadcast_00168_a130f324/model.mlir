module {
  func.func @kernel(%arg0: tensor<33x9xi16>, %arg1: tensor<33x22x9xi16>) -> tensor<33x22x9xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<33x22x9xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<33x9xi16>) outs(%arg1 : tensor<33x22x9xi16>) dimensions = [1]
      NAIL.yield %z : tensor<33x22x9xi16>
    }
    return %r : tensor<33x22x9xi16>
  }
}
