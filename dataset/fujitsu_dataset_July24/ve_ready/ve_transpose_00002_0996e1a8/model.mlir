module {
  func.func @kernel(%arg0: tensor<122x25x46xi16>, %arg1: tensor<46x25x122xi16>) -> tensor<46x25x122xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<46x25x122xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<122x25x46xi16>) outs(%arg1 : tensor<46x25x122xi16>) permutation = [2, 1, 0]
      NAIL.yield %z : tensor<46x25x122xi16>
    }
    return %r : tensor<46x25x122xi16>
  }
}
