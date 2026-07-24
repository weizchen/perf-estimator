module {
  func.func @kernel(%arg0: tensor<248xi1>, %arg1: tensor<248xf16>, %arg2: tensor<248xf16>, %arg3: tensor<248xf16>) -> tensor<248xf16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<248xf16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<248xi1>, tensor<248xf16>, tensor<248xf16>) outs(%arg3 : tensor<248xf16>) -> tensor<248xf16>
      NAIL.yield %z : tensor<248xf16>
    }
    return %r : tensor<248xf16>
  }
}
