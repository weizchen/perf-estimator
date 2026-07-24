module {
  func.func @kernel(%arg0: tensor<15x473xi1>, %arg1: tensor<15x473xi16>, %arg2: tensor<15x473xi16>, %arg3: tensor<15x473xi16>) -> tensor<15x473xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<15x473xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<15x473xi1>, tensor<15x473xi16>, tensor<15x473xi16>) outs(%arg3 : tensor<15x473xi16>) -> tensor<15x473xi16>
      NAIL.yield %z : tensor<15x473xi16>
    }
    return %r : tensor<15x473xi16>
  }
}
