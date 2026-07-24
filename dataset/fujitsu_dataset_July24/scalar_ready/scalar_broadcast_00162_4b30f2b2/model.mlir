module {
  func.func @kernel(%arg0: tensor<202x143xi16>, %arg1: tensor<202x143x56xi16>) -> tensor<202x143x56xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<202x143x56xi16> {
    %z = linalg.broadcast ins(%arg0 : tensor<202x143xi16>) outs(%arg1 : tensor<202x143x56xi16>) dimensions = [2]
      NAIL.yield %z : tensor<202x143x56xi16>
    }
    return %r : tensor<202x143x56xi16>
  }
}
