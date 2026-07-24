module {
  func.func @kernel(%arg0: tensor<340x32x22xbf16>, %arg1: tensor<340x32x22xbf16>) -> tensor<340x32x22xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<340x32x22xbf16> {
    %z = linalg.copy ins(%arg0 : tensor<340x32x22xbf16>) outs(%arg1 : tensor<340x32x22xbf16>) -> tensor<340x32x22xbf16>
      NAIL.yield %z : tensor<340x32x22xbf16>
    }
    return %r : tensor<340x32x22xbf16>
  }
}
