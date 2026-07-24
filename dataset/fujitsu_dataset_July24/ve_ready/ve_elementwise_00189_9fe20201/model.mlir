module {
  func.func @kernel(%arg0: tensor<12x22xbf16>, %arg1: tensor<12x22xbf16>, %arg2: tensor<12x22xbf16>) -> tensor<12x22xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<12x22xbf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<mul> ins(%arg0, %arg1 : tensor<12x22xbf16>, tensor<12x22xbf16>) outs(%arg2 : tensor<12x22xbf16>) -> tensor<12x22xbf16>
      NAIL.yield %z : tensor<12x22xbf16>
    }
    return %r : tensor<12x22xbf16>
  }
}
