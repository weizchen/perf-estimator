module {
  func.func @kernel(%arg0: tensor<165x32xf16>, %arg1: tensor<32x165xf16>) -> tensor<32x165xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<32x165xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<165x32xf16>) outs(%arg1 : tensor<32x165xf16>) permutation = [1, 0]
      NAIL.yield %z : tensor<32x165xf16>
    }
    return %r : tensor<32x165xf16>
  }
}
