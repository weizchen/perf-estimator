module {
  func.func @kernel(%arg0: tensor<384x768xi8>, %arg1: tensor<768x384xi8>, %arg2: tensor<384x384xi32>) -> tensor<384x384xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<384x384xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<384x768xi8>, tensor<768x384xi8>) outs(%arg2 : tensor<384x384xi32>) -> tensor<384x384xi32>
      NAIL.yield %m : tensor<384x384xi32>
    }
    return %r : tensor<384x384xi32>
  }
}
