module {
  func.func @kernel(%arg0: tensor<1536xi8>, %arg1: tensor<1536x384xi8>, %arg2: tensor<384xi32>) -> tensor<384xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<384xi32> {
    %z = linalg.vecmat ins(%arg0, %arg1 : tensor<1536xi8>, tensor<1536x384xi8>) outs(%arg2 : tensor<384xi32>) -> tensor<384xi32>
      NAIL.yield %z : tensor<384xi32>
    }
    return %r : tensor<384xi32>
  }
}
