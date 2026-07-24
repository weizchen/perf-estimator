module {
  func.func @kernel(%arg0: tensor<78x225xf16>, %arg1: tensor<78x225xf16>, %arg2: tensor<78x225xf16>) -> tensor<78x225xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<78x225xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<min_signed> ins(%arg0, %arg1 : tensor<78x225xf16>, tensor<78x225xf16>) outs(%arg2 : tensor<78x225xf16>) -> tensor<78x225xf16>
      NAIL.yield %z : tensor<78x225xf16>
    }
    return %r : tensor<78x225xf16>
  }
}
