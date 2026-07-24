module {
  func.func @kernel(%arg0: tensor<8x269xi16>, %arg1: tensor<8x269xi16>, %arg2: tensor<8x269xi16>) -> tensor<8x269xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<8x269xi16> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<min_signed> ins(%arg0, %arg1 : tensor<8x269xi16>, tensor<8x269xi16>) outs(%arg2 : tensor<8x269xi16>) -> tensor<8x269xi16>
      NAIL.yield %z : tensor<8x269xi16>
    }
    return %r : tensor<8x269xi16>
  }
}
