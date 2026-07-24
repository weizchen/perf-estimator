module {
  func.func @kernel(%arg0: tensor<8x6x60xi16>, %arg1: tensor<8x60x6xi16>) -> tensor<8x60x6xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<8x60x6xi16> {
    %z = linalg.transpose ins(%arg0 : tensor<8x6x60xi16>) outs(%arg1 : tensor<8x60x6xi16>) permutation = [0, 2, 1]
      NAIL.yield %z : tensor<8x60x6xi16>
    }
    return %r : tensor<8x60x6xi16>
  }
}
