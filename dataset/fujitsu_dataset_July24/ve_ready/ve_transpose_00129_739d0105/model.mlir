module {
  func.func @kernel(%arg0: tensor<77x78xbf16>, %arg1: tensor<78x77xbf16>) -> tensor<78x77xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<78x77xbf16> {
    %z = linalg.transpose ins(%arg0 : tensor<77x78xbf16>) outs(%arg1 : tensor<78x77xbf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<78x77xbf16>
    }
    return %r : tensor<78x77xbf16>
  }
}
