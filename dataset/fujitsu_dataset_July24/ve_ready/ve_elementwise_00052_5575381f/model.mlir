module {
  func.func @kernel(%arg0: tensor<175x4xbf16>, %arg1: tensor<175x4xbf16>, %arg2: tensor<175x4xbf16>) -> tensor<175x4xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<175x4xbf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<sub> ins(%arg0, %arg1 : tensor<175x4xbf16>, tensor<175x4xbf16>) outs(%arg2 : tensor<175x4xbf16>) -> tensor<175x4xbf16>
      NAIL.yield %z : tensor<175x4xbf16>
    }
    return %r : tensor<175x4xbf16>
  }
}
