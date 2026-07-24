module {
  func.func @kernel(%arg0: tensor<18x12xf16>, %arg1: tensor<18x12xf16>, %arg2: tensor<18x12xf16>) -> tensor<18x12xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<18x12xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<sub> ins(%arg0, %arg1 : tensor<18x12xf16>, tensor<18x12xf16>) outs(%arg2 : tensor<18x12xf16>) -> tensor<18x12xf16>
      NAIL.yield %z : tensor<18x12xf16>
    }
    return %r : tensor<18x12xf16>
  }
}
