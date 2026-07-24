module {
  func.func @kernel(%arg0: tensor<6xi1>, %arg1: tensor<6xi16>, %arg2: tensor<6xi16>, %arg3: tensor<6xi16>) -> tensor<6xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<6xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<6xi1>, tensor<6xi16>, tensor<6xi16>) outs(%arg3 : tensor<6xi16>) -> tensor<6xi16>
      NAIL.yield %z : tensor<6xi16>
    }
    return %r : tensor<6xi16>
  }
}
