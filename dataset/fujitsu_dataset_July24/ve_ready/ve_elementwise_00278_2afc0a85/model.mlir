module {
  func.func @kernel(%arg0: tensor<106xf16>, %arg1: tensor<106xf16>, %arg2: tensor<106xf16>) -> tensor<106xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<106xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<div> ins(%arg0, %arg1 : tensor<106xf16>, tensor<106xf16>) outs(%arg2 : tensor<106xf16>) -> tensor<106xf16>
      NAIL.yield %z : tensor<106xf16>
    }
    return %r : tensor<106xf16>
  }
}
