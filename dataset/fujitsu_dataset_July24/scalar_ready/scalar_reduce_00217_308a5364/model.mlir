module {
  func.func @kernel(%arg0: tensor<76x63x20xi8>, %arg1: tensor<76x20xi8>) -> tensor<76x20xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<76x20xi8> {
    %z = linalg.reduce ins(%arg0 : tensor<76x63x20xi8>) outs(%arg1 : tensor<76x20xi8>) dimensions = [1]
      (%in: i8, %acc: i8) {
        %s = arith.addi %in, %acc : i8
        linalg.yield %s : i8
      }
      NAIL.yield %z : tensor<76x20xi8>
    }
    return %r : tensor<76x20xi8>
  }
}
