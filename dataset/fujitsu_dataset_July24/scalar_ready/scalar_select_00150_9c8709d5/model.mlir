module {
  func.func @kernel(%arg0: tensor<140xi1>, %arg1: tensor<140xi8>, %arg2: tensor<140xi8>, %arg3: tensor<140xi8>) -> tensor<140xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<140xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<140xi1>, tensor<140xi8>, tensor<140xi8>) outs(%arg3 : tensor<140xi8>) -> tensor<140xi8>
      NAIL.yield %z : tensor<140xi8>
    }
    return %r : tensor<140xi8>
  }
}
