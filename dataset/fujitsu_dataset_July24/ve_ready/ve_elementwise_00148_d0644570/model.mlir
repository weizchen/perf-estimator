module {
  func.func @kernel(%arg0: tensor<104x141xi16>, %arg1: tensor<104x141xi16>, %arg2: tensor<104x141xi16>) -> tensor<104x141xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<104x141xi16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<sub> ins(%arg0, %arg1 : tensor<104x141xi16>, tensor<104x141xi16>) outs(%arg2 : tensor<104x141xi16>) -> tensor<104x141xi16>
      NAIL.yield %z : tensor<104x141xi16>
    }
    return %r : tensor<104x141xi16>
  }
}
