module {
  func.func @kernel(%arg0: tensor<6x9x24x32xi16>, %arg1: tensor<6x32x24x9xi16>) -> tensor<6x32x24x9xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<6x32x24x9xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<6x9x24x32xi16>) outs(%arg1 : tensor<6x32x24x9xi16>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<6x32x24x9xi16>
    }
    return %r : tensor<6x32x24x9xi16>
  }
}
