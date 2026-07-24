module {
  func.func @kernel(%arg0: tensor<152xi1>, %arg1: tensor<152xi16>, %arg2: tensor<152xi16>, %arg3: tensor<152xi16>) -> tensor<152xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<152xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<152xi1>, tensor<152xi16>, tensor<152xi16>) outs(%arg3 : tensor<152xi16>) -> tensor<152xi16>
      NAIL.yield %z : tensor<152xi16>
    }
    return %r : tensor<152xi16>
  }
}
