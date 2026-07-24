module {
  func.func @kernel(%arg0: tensor<7x5xi1>, %arg1: tensor<7x5xf16>, %arg2: tensor<7x5xf16>, %arg3: tensor<7x5xf16>) -> tensor<7x5xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<7x5xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<7x5xi1>, tensor<7x5xf16>, tensor<7x5xf16>) outs(%arg3 : tensor<7x5xf16>) -> tensor<7x5xf16>
      NAIL.yield %z : tensor<7x5xf16>
    }
    return %r : tensor<7x5xf16>
  }
}
