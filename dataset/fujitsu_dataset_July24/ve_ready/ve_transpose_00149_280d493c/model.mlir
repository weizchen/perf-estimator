module {
  func.func @kernel(%arg0: tensor<8x47x26xi16>, %arg1: tensor<47x8x26xi16>) -> tensor<47x8x26xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<47x8x26xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<8x47x26xi16>) outs(%arg1 : tensor<47x8x26xi16>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<47x8x26xi16>
    }
    return %r : tensor<47x8x26xi16>
  }
}
