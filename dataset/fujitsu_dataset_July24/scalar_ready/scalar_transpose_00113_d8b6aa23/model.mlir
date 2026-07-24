module {
  func.func @kernel(%arg0: tensor<42x15x25x37xf16>, %arg1: tensor<42x15x37x25xf16>) -> tensor<42x15x37x25xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<42x15x37x25xf16> {
    %z = linalg.transpose ins(%arg0 : tensor<42x15x25x37xf16>) outs(%arg1 : tensor<42x15x37x25xf16>) permutation = [0, 1, 3, 2]
      NAIL.yield %z : tensor<42x15x37x25xf16>
    }
    return %r : tensor<42x15x37x25xf16>
  }
}
