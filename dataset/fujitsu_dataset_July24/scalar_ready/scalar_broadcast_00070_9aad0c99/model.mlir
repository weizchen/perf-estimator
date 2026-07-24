module {
  func.func @kernel(%arg0: tensor<219x185xf16>, %arg1: tensor<219x41x185xf16>) -> tensor<219x41x185xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<219x41x185xf16> {
    %z = linalg.broadcast ins(%arg0 : tensor<219x185xf16>) outs(%arg1 : tensor<219x41x185xf16>) dimensions = [1]
      NAIL.yield %z : tensor<219x41x185xf16>
    }
    return %r : tensor<219x41x185xf16>
  }
}
