module {
  func.func @kernel(%arg0: tensor<79x64x81xf16>, %arg1: tensor<64x79x81xf16>) -> tensor<64x79x81xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<64x79x81xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<79x64x81xf16>) outs(%arg1 : tensor<64x79x81xf16>) permutation = [1, 0, 2]
      NAIL.yield %z : tensor<64x79x81xf16>
    }
    return %r : tensor<64x79x81xf16>
  }
}
