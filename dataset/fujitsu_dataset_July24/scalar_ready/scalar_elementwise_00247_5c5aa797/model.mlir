module {
  func.func @kernel(%arg0: tensor<161x6xi16>, %arg1: tensor<161x6xi16>, %arg2: tensor<161x6xi16>) -> tensor<161x6xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<161x6xi16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<min_signed> ins(%arg0, %arg1 : tensor<161x6xi16>, tensor<161x6xi16>) outs(%arg2 : tensor<161x6xi16>) -> tensor<161x6xi16>
      NAIL.yield %z : tensor<161x6xi16>
    }
    return %r : tensor<161x6xi16>
  }
}
