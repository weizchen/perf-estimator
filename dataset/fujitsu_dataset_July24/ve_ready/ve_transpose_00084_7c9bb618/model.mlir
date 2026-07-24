module {
  func.func @kernel(%arg0: tensor<90x105x40xi16>, %arg1: tensor<40x105x90xi16>) -> tensor<40x105x90xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<40x105x90xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<90x105x40xi16>) outs(%arg1 : tensor<40x105x90xi16>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<40x105x90xi16>
    }
    return %r : tensor<40x105x90xi16>
  }
}
