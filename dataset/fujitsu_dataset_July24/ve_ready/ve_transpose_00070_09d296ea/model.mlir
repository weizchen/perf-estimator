module {
  func.func @kernel(%arg0: tensor<149x324xbf16>, %arg1: tensor<324x149xbf16>) -> tensor<324x149xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<324x149xbf16> {
    %z = linalg.transpose ins(%arg0 : tensor<149x324xbf16>) outs(%arg1 : tensor<324x149xbf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<324x149xbf16>
    }
    return %r : tensor<324x149xbf16>
  }
}
