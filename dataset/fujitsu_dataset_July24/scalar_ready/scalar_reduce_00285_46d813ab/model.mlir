module {
  func.func @kernel(%arg0: tensor<27x401x214xi8>, %arg1: tensor<27x214xi8>) -> tensor<27x214xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<27x214xi8> {
    %z = linalg.reduce ins(%arg0 : tensor<27x401x214xi8>) outs(%arg1 : tensor<27x214xi8>) dimensions = [1]
      (%in: i8, %acc: i8) {
        %s = arith.maxsi %in, %acc : i8
        linalg.yield %s : i8
      }
      NAIL.yield %z : tensor<27x214xi8>
    }
    return %r : tensor<27x214xi8>
  }
}
