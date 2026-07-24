module {
  func.func @kernel(%arg0: tensor<10x27xi1>, %arg1: tensor<10x27xi8>, %arg2: tensor<10x27xi8>, %arg3: tensor<10x27xi8>) -> tensor<10x27xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<10x27xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<10x27xi1>, tensor<10x27xi8>, tensor<10x27xi8>) outs(%arg3 : tensor<10x27xi8>) -> tensor<10x27xi8>
      NAIL.yield %z : tensor<10x27xi8>
    }
    return %r : tensor<10x27xi8>
  }
}
