module {
  func.func @kernel(%arg0: tensor<480x150x25xbf16>, %arg1: tensor<480x150x25xbf16>) -> tensor<480x150x25xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<480x150x25xbf16> {
    %z = linalg.copy ins(%arg0 : tensor<480x150x25xbf16>) outs(%arg1 : tensor<480x150x25xbf16>) -> tensor<480x150x25xbf16>
      NAIL.yield %z : tensor<480x150x25xbf16>
    }
    return %r : tensor<480x150x25xbf16>
  }
}
