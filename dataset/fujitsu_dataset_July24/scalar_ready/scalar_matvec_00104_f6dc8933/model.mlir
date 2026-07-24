module {
  func.func @kernel(%arg0: tensor<384x128xi8>, %arg1: tensor<128xi8>, %arg2: tensor<384xi32>) -> tensor<384xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<384xi32> {
    %z = linalg.matvec ins(%arg0, %arg1 : tensor<384x128xi8>, tensor<128xi8>) outs(%arg2 : tensor<384xi32>) -> tensor<384xi32>
      NAIL.yield %z : tensor<384xi32>
    }
    return %r : tensor<384xi32>
  }
}
