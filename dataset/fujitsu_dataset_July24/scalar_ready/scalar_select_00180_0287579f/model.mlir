module {
  func.func @kernel(%arg0: tensor<36xi1>, %arg1: tensor<36xf16>, %arg2: tensor<36xf16>, %arg3: tensor<36xf16>) -> tensor<36xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<36xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<36xi1>, tensor<36xf16>, tensor<36xf16>) outs(%arg3 : tensor<36xf16>) -> tensor<36xf16>
      NAIL.yield %z : tensor<36xf16>
    }
    return %r : tensor<36xf16>
  }
}
