module {
  func.func @kernel(%arg0: tensor<5x9x43x5xbf16>, %arg1: tensor<5x43x9x5xbf16>) -> tensor<5x43x9x5xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<5x43x9x5xbf16> {
    %z = linalg.transpose ins(%arg0 : tensor<5x9x43x5xbf16>) outs(%arg1 : tensor<5x43x9x5xbf16>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<5x43x9x5xbf16>
    }
    return %r : tensor<5x43x9x5xbf16>
  }
}
