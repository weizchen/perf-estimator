module {
  func.func @kernel(%arg0: tensor<41x30x88xi16>, %arg1: tensor<88x30x41xi16>) -> tensor<88x30x41xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<88x30x41xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<41x30x88xi16>) outs(%arg1 : tensor<88x30x41xi16>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<88x30x41xi16>
    }
    return %r : tensor<88x30x41xi16>
  }
}
