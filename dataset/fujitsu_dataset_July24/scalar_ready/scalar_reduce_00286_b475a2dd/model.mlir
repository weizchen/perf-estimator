module {
  func.func @kernel(%arg0: tensor<14x135xi8>, %arg1: tensor<135xi8>) -> tensor<135xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<135xi8> {
    %z = linalg.reduce ins(%arg0 : tensor<14x135xi8>) outs(%arg1 : tensor<135xi8>) dimensions = [0]
      (%in: i8, %acc: i8) {
        %s = arith.maxsi %in, %acc : i8
        linalg.yield %s : i8
      }
      NAIL.yield %z : tensor<135xi8>
    }
    return %r : tensor<135xi8>
  }
}
