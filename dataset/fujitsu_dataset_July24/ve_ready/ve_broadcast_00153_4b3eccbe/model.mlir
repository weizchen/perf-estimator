module {
  func.func @kernel(%arg0: tensor<291x78xi16>, %arg1: tensor<291x11x78xi16>) -> tensor<291x11x78xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<291x11x78xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<291x78xi16>) outs(%arg1 : tensor<291x11x78xi16>) dimensions = [1]
      NAIL.yield %z : tensor<291x11x78xi16>
    }
    return %r : tensor<291x11x78xi16>
  }
}
