module {
  func.func @kernel(%arg0: tensor<13xi1>, %arg1: tensor<13xi16>, %arg2: tensor<13xi16>, %arg3: tensor<13xi16>) -> tensor<13xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<13xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<13xi1>, tensor<13xi16>, tensor<13xi16>) outs(%arg3 : tensor<13xi16>) -> tensor<13xi16>
      NAIL.yield %z : tensor<13xi16>
    }
    return %r : tensor<13xi16>
  }
}
