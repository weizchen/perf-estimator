module {
  func.func @kernel(%arg0: tensor<57xf16>, %arg1: tensor<57xf16>, %arg2: tensor<57xf16>) -> tensor<57xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<57xf16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<max_signed> ins(%arg0, %arg1 : tensor<57xf16>, tensor<57xf16>) outs(%arg2 : tensor<57xf16>) -> tensor<57xf16>
      NAIL.yield %z : tensor<57xf16>
    }
    return %r : tensor<57xf16>
  }
}
