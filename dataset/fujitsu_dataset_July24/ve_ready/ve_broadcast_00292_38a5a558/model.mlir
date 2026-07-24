module {
  func.func @kernel(%arg0: tensor<12xi8>, %arg1: tensor<12x233xi8>) -> tensor<12x233xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<12x233xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<12xi8>) outs(%arg1 : tensor<12x233xi8>) dimensions = [1]
      NAIL.yield %z : tensor<12x233xi8>
    }
    return %r : tensor<12x233xi8>
  }
}
