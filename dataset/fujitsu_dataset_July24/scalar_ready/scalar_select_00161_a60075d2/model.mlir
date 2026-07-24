module {
  func.func @kernel(%arg0: tensor<42x17xi1>, %arg1: tensor<42x17xi8>, %arg2: tensor<42x17xi8>, %arg3: tensor<42x17xi8>) -> tensor<42x17xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<42x17xi8> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<42x17xi1>, tensor<42x17xi8>, tensor<42x17xi8>) outs(%arg3 : tensor<42x17xi8>) -> tensor<42x17xi8>
      NAIL.yield %z : tensor<42x17xi8>
    }
    return %r : tensor<42x17xi8>
  }
}
