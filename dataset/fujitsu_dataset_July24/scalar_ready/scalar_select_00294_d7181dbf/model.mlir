module {
  func.func @kernel(%arg0: tensor<115xi1>, %arg1: tensor<115xi8>, %arg2: tensor<115xi8>, %arg3: tensor<115xi8>) -> tensor<115xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<115xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<115xi1>, tensor<115xi8>, tensor<115xi8>) outs(%arg3 : tensor<115xi8>) -> tensor<115xi8>
      NAIL.yield %z : tensor<115xi8>
    }
    return %r : tensor<115xi8>
  }
}
