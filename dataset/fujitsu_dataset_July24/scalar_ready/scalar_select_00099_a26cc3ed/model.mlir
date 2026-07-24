module {
  func.func @kernel(%arg0: tensor<5x5xi1>, %arg1: tensor<5x5xi8>, %arg2: tensor<5x5xi8>, %arg3: tensor<5x5xi8>) -> tensor<5x5xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<5x5xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<5x5xi1>, tensor<5x5xi8>, tensor<5x5xi8>) outs(%arg3 : tensor<5x5xi8>) -> tensor<5x5xi8>
      NAIL.yield %z : tensor<5x5xi8>
    }
    return %r : tensor<5x5xi8>
  }
}
