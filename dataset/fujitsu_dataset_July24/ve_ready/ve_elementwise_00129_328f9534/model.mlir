module {
  func.func @kernel(%arg0: tensor<17x148xf16>, %arg1: tensor<17x148xf16>, %arg2: tensor<17x148xf16>) -> tensor<17x148xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<17x148xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<add> ins(%arg0, %arg1 : tensor<17x148xf16>, tensor<17x148xf16>) outs(%arg2 : tensor<17x148xf16>) -> tensor<17x148xf16>
      NAIL.yield %z : tensor<17x148xf16>
    }
    return %r : tensor<17x148xf16>
  }
}
