module {
  func.func @kernel(%arg0: tensor<448xf16>, %arg1: tensor<448x1152xf16>, %arg2: tensor<1152xf16>) -> tensor<1152xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1152xf16> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<448xf16>, tensor<448x1152xf16>) outs(%arg2 : tensor<1152xf16>) -> tensor<1152xf16>
      NAIL.yield %z : tensor<1152xf16>
    }
    return %r : tensor<1152xf16>
  }
}
