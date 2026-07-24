module {
  func.func @kernel(%arg0: tensor<4x19xi1>, %arg1: tensor<4x19xi16>, %arg2: tensor<4x19xi16>, %arg3: tensor<4x19xi16>) -> tensor<4x19xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4x19xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<4x19xi1>, tensor<4x19xi16>, tensor<4x19xi16>) outs(%arg3 : tensor<4x19xi16>) -> tensor<4x19xi16>
      NAIL.yield %z : tensor<4x19xi16>
    }
    return %r : tensor<4x19xi16>
  }
}
