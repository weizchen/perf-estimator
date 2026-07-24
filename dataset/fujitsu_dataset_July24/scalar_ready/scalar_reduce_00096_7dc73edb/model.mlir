module {
  func.func @kernel(%arg0: tensor<8x311x393xi8>, %arg1: tensor<311x393xi8>) -> tensor<311x393xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<311x393xi8> {
    %z = linalg.reduce ins(%arg0 : tensor<8x311x393xi8>) outs(%arg1 : tensor<311x393xi8>) dimensions = [0]
      (%in: i8, %acc: i8) {
        %s = arith.muli %in, %acc : i8
        linalg.yield %s : i8
      }
      NAIL.yield %z : tensor<311x393xi8>
    }
    return %r : tensor<311x393xi8>
  }
}
