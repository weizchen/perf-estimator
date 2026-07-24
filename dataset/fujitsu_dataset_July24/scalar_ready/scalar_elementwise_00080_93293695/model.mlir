module {
  func.func @kernel(%arg0: tensor<183x7xf16>, %arg1: tensor<183x7xf16>, %arg2: tensor<183x7xf16>) -> tensor<183x7xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<183x7xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<sub> ins(%arg0, %arg1 : tensor<183x7xf16>, tensor<183x7xf16>) outs(%arg2 : tensor<183x7xf16>) -> tensor<183x7xf16>
      NAIL.yield %z : tensor<183x7xf16>
    }
    return %r : tensor<183x7xf16>
  }
}
