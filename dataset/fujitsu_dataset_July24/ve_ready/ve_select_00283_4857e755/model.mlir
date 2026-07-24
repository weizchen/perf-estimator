module {
  func.func @kernel(%arg0: tensor<62x341xi1>, %arg1: tensor<62x341xi16>, %arg2: tensor<62x341xi16>, %arg3: tensor<62x341xi16>) -> tensor<62x341xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<62x341xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<62x341xi1>, tensor<62x341xi16>, tensor<62x341xi16>) outs(%arg3 : tensor<62x341xi16>) -> tensor<62x341xi16>
      NAIL.yield %z : tensor<62x341xi16>
    }
    return %r : tensor<62x341xi16>
  }
}
