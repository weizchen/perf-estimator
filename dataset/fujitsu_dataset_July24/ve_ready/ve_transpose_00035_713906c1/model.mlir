module {
  func.func @kernel(%arg0: tensor<27x23x6x4xi16>, %arg1: tensor<27x4x6x23xi16>) -> tensor<27x4x6x23xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<27x4x6x23xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<27x23x6x4xi16>) outs(%arg1 : tensor<27x4x6x23xi16>) permutation = [0, 3, 2, 1]
      NAIL.yield %z : tensor<27x4x6x23xi16>
    }
    return %r : tensor<27x4x6x23xi16>
  }
}
