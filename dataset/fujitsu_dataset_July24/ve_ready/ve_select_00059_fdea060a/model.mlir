module {
  func.func @kernel(%arg0: tensor<20x112xi1>, %arg1: tensor<20x112xi8>, %arg2: tensor<20x112xi8>, %arg3: tensor<20x112xi8>) -> tensor<20x112xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<20x112xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<20x112xi1>, tensor<20x112xi8>, tensor<20x112xi8>) outs(%arg3 : tensor<20x112xi8>) -> tensor<20x112xi8>
      NAIL.yield %z : tensor<20x112xi8>
    }
    return %r : tensor<20x112xi8>
  }
}
