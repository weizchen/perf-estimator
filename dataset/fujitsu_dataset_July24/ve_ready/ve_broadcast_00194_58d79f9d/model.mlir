module {
  func.func @kernel(%arg0: tensor<499x161xbf16>, %arg1: tensor<499x161x161xbf16>) -> tensor<499x161x161xbf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<499x161x161xbf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<499x161xbf16>) outs(%arg1 : tensor<499x161x161xbf16>) dimensions = [2]
      NAIL.yield %z : tensor<499x161x161xbf16>
    }
    return %r : tensor<499x161x161xbf16>
  }
}
