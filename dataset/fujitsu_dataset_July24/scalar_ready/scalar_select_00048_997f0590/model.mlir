module {
  func.func @kernel(%arg0: tensor<14xi1>, %arg1: tensor<14xi8>, %arg2: tensor<14xi8>, %arg3: tensor<14xi8>) -> tensor<14xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<14xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<14xi1>, tensor<14xi8>, tensor<14xi8>) outs(%arg3 : tensor<14xi8>) -> tensor<14xi8>
      NAIL.yield %z : tensor<14xi8>
    }
    return %r : tensor<14xi8>
  }
}
