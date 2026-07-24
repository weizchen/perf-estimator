module {
  func.func @kernel(%arg0: tensor<233x50x50xi8>, %arg1: tensor<50x50xi8>) -> tensor<50x50xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<50x50xi8> {
    %z = linalg.reduce ins(%arg0 : tensor<233x50x50xi8>) outs(%arg1 : tensor<50x50xi8>) dimensions = [0]
      (%in: i8, %acc: i8) {
        %s = arith.muli %in, %acc : i8
        linalg.yield %s : i8
      }
      NAIL.yield %z : tensor<50x50xi8>
    }
    return %r : tensor<50x50xi8>
  }
}
