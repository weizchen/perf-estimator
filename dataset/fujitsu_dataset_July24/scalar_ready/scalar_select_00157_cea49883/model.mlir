module {
  func.func @kernel(%arg0: tensor<68x4xi1>, %arg1: tensor<68x4xf16>, %arg2: tensor<68x4xf16>, %arg3: tensor<68x4xf16>) -> tensor<68x4xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<68x4xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<68x4xi1>, tensor<68x4xf16>, tensor<68x4xf16>) outs(%arg3 : tensor<68x4xf16>) -> tensor<68x4xf16>
      NAIL.yield %z : tensor<68x4xf16>
    }
    return %r : tensor<68x4xf16>
  }
}
