module {
  func.func @kernel(%arg0: tensor<104x17xf16>, %arg1: tensor<104x17x22xf16>) -> tensor<104x17x22xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<104x17x22xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<104x17xf16>) outs(%arg1 : tensor<104x17x22xf16>) dimensions = [2]
      NAIL.yield %z : tensor<104x17x22xf16>
    }
    return %r : tensor<104x17x22xf16>
  }
}
