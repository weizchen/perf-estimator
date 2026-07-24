module {
  func.func @kernel(%arg0: tensor<34xbf16>, %arg1: tensor<34xbf16>, %arg2: tensor<34xbf16>) -> tensor<34xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<34xbf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<sub> ins(%arg0, %arg1 : tensor<34xbf16>, tensor<34xbf16>) outs(%arg2 : tensor<34xbf16>) -> tensor<34xbf16>
      NAIL.yield %z : tensor<34xbf16>
    }
    return %r : tensor<34xbf16>
  }
}
