module {
  func.func @kernel(%arg0: tensor<261x270xf16>, %arg1: tensor<261x194x270xf16>) -> tensor<261x194x270xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<261x194x270xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<261x270xf16>) outs(%arg1 : tensor<261x194x270xf16>) dimensions = [1]
      NAIL.yield %z : tensor<261x194x270xf16>
    }
    return %r : tensor<261x194x270xf16>
  }
}
