module {
  func.func @kernel(%arg0: tensor<145x7xf16>, %arg1: tensor<145x7xf16>) -> tensor<145x7xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<145x7xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<negf> ins(%arg0 : tensor<145x7xf16>) outs(%arg1 : tensor<145x7xf16>) -> tensor<145x7xf16>
      NAIL.yield %z : tensor<145x7xf16>
    }
    return %r : tensor<145x7xf16>
  }
}
