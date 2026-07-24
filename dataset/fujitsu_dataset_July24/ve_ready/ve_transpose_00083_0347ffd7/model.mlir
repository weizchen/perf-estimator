module {
  func.func @kernel(%arg0: tensor<9x19x43x37xf16>, %arg1: tensor<9x43x19x37xf16>) -> tensor<9x43x19x37xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<9x43x19x37xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<9x19x43x37xf16>) outs(%arg1 : tensor<9x43x19x37xf16>) permutation = [0, 2, 1, 3]
      NAIL.yield %z : tensor<9x43x19x37xf16>
    }
    return %r : tensor<9x43x19x37xf16>
  }
}
