module {
  func.func @kernel(%arg0: tensor<78x24xi8>, %arg1: tensor<112x78x24xi8>) -> tensor<112x78x24xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<112x78x24xi8> {
    %z = linalg.broadcast ins(%arg0 : tensor<78x24xi8>) outs(%arg1 : tensor<112x78x24xi8>) dimensions = [0]
      NAIL.yield %z : tensor<112x78x24xi8>
    }
    return %r : tensor<112x78x24xi8>
  }
}
