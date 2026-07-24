module {
  func.func @kernel(%arg0: tensor<5x202xi1>, %arg1: tensor<5x202xf16>, %arg2: tensor<5x202xf16>, %arg3: tensor<5x202xf16>) -> tensor<5x202xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<5x202xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<5x202xi1>, tensor<5x202xf16>, tensor<5x202xf16>) outs(%arg3 : tensor<5x202xf16>) -> tensor<5x202xf16>
      NAIL.yield %z : tensor<5x202xf16>
    }
    return %r : tensor<5x202xf16>
  }
}
