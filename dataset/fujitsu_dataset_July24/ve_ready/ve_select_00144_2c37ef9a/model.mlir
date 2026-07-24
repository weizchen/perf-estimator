module {
  func.func @kernel(%arg0: tensor<59x11xi1>, %arg1: tensor<59x11xi16>, %arg2: tensor<59x11xi16>, %arg3: tensor<59x11xi16>) -> tensor<59x11xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<59x11xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<59x11xi1>, tensor<59x11xi16>, tensor<59x11xi16>) outs(%arg3 : tensor<59x11xi16>) -> tensor<59x11xi16>
      NAIL.yield %z : tensor<59x11xi16>
    }
    return %r : tensor<59x11xi16>
  }
}
