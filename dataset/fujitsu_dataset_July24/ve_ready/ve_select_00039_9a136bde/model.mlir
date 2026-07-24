module {
  func.func @kernel(%arg0: tensor<34xi1>, %arg1: tensor<34xi8>, %arg2: tensor<34xi8>, %arg3: tensor<34xi8>) -> tensor<34xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<34xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<34xi1>, tensor<34xi8>, tensor<34xi8>) outs(%arg3 : tensor<34xi8>) -> tensor<34xi8>
      NAIL.yield %z : tensor<34xi8>
    }
    return %r : tensor<34xi8>
  }
}
