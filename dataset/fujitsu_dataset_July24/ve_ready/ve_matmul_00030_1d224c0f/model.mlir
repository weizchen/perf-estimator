module {
  func.func @kernel(%arg0: tensor<3584x128xi8>, %arg1: tensor<128x1920xi8>, %arg2: tensor<3584x1920xi32>) -> tensor<3584x1920xi32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<3584x1920xi32> {
      %m = linalg.matmul ins(%arg0, %arg1 : tensor<3584x128xi8>, tensor<128x1920xi8>) outs(%arg2 : tensor<3584x1920xi32>) -> tensor<3584x1920xi32>
      NAIL.yield %m : tensor<3584x1920xi32>
    }
    return %r : tensor<3584x1920xi32>
  }
}
