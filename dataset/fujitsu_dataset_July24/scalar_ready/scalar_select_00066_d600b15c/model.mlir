module {
  func.func @kernel(%arg0: tensor<11xi1>, %arg1: tensor<11xi8>, %arg2: tensor<11xi8>, %arg3: tensor<11xi8>) -> tensor<11xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<11xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<11xi1>, tensor<11xi8>, tensor<11xi8>) outs(%arg3 : tensor<11xi8>) -> tensor<11xi8>
      NAIL.yield %z : tensor<11xi8>
    }
    return %r : tensor<11xi8>
  }
}
