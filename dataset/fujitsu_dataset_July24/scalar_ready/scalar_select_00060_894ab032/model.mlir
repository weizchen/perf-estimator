module {
  func.func @kernel(%arg0: tensor<484xi1>, %arg1: tensor<484xi16>, %arg2: tensor<484xi16>, %arg3: tensor<484xi16>) -> tensor<484xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<484xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<484xi1>, tensor<484xi16>, tensor<484xi16>) outs(%arg3 : tensor<484xi16>) -> tensor<484xi16>
      NAIL.yield %z : tensor<484xi16>
    }
    return %r : tensor<484xi16>
  }
}
