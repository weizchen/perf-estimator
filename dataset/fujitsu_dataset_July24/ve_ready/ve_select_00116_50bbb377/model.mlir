module {
  func.func @kernel(%arg0: tensor<4x17xi1>, %arg1: tensor<4x17xf32>, %arg2: tensor<4x17xf32>, %arg3: tensor<4x17xf32>) -> tensor<4x17xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<4x17xf32> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<4x17xi1>, tensor<4x17xf32>, tensor<4x17xf32>) outs(%arg3 : tensor<4x17xf32>) -> tensor<4x17xf32>
      NAIL.yield %z : tensor<4x17xf32>
    }
    return %r : tensor<4x17xf32>
  }
}
