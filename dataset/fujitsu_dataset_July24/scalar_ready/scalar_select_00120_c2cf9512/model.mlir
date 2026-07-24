module {
  func.func @kernel(%arg0: tensor<94x5xi1>, %arg1: tensor<94x5xf16>, %arg2: tensor<94x5xf16>, %arg3: tensor<94x5xf16>) -> tensor<94x5xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<94x5xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<94x5xi1>, tensor<94x5xf16>, tensor<94x5xf16>) outs(%arg3 : tensor<94x5xf16>) -> tensor<94x5xf16>
      NAIL.yield %z : tensor<94x5xf16>
    }
    return %r : tensor<94x5xf16>
  }
}
