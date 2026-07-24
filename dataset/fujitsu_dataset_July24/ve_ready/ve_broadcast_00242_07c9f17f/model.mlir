module {
  func.func @kernel(%arg0: tensor<6x438xi8>, %arg1: tensor<22x6x438xi8>) -> tensor<22x6x438xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<22x6x438xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<6x438xi8>) outs(%arg1 : tensor<22x6x438xi8>) dimensions = [0]
      NAIL.yield %z : tensor<22x6x438xi8>
    }
    return %r : tensor<22x6x438xi8>
  }
}
