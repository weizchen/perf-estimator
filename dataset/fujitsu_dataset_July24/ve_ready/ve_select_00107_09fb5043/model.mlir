module {
  func.func @kernel(%arg0: tensor<7xi1>, %arg1: tensor<7xi8>, %arg2: tensor<7xi8>, %arg3: tensor<7xi8>) -> tensor<7xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<7xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<7xi1>, tensor<7xi8>, tensor<7xi8>) outs(%arg3 : tensor<7xi8>) -> tensor<7xi8>
      NAIL.yield %z : tensor<7xi8>
    }
    return %r : tensor<7xi8>
  }
}
