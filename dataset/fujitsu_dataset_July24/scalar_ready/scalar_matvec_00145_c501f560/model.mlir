module {
  func.func @kernel(%arg0: tensor<1664x704xf16>, %arg1: tensor<704xf16>, %arg2: tensor<1664xf32>) -> tensor<1664xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<1664xf32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<1664x704xf16>, tensor<704xf16>) outs(%arg2 : tensor<1664xf32>) -> tensor<1664xf32>
      NAIL.yield %z : tensor<1664xf32>
    }
    return %r : tensor<1664xf32>
  }
}
