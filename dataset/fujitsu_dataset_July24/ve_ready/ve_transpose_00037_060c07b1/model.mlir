module {
  func.func @kernel(%arg0: tensor<11x20x66xi16>, %arg1: tensor<20x11x66xi16>) -> tensor<20x11x66xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<20x11x66xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<11x20x66xi16>) outs(%arg1 : tensor<20x11x66xi16>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<20x11x66xi16>
    }
    return %r : tensor<20x11x66xi16>
  }
}
