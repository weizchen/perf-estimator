module {
  func.func @kernel(%arg0: tensor<3712x2944xi8>, %arg1: tensor<2944x384xi8>, %arg2: tensor<3712x384xi32>) -> tensor<3712x384xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3712x384xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3712x2944xi8>, tensor<2944x384xi8>) outs(%arg2 : tensor<3712x384xi32>) -> tensor<3712x384xi32>
      NAIL.yield %m : tensor<3712x384xi32>
    }
    return %r : tensor<3712x384xi32>
  }
}
