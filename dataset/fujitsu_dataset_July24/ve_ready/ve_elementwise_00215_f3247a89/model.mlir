module {
  func.func @kernel(%arg0: tensor<17xf32>, %arg1: tensor<17xf32>, %arg2: tensor<17xf32>) -> tensor<17xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<17xf32> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<div> ins(%arg0, %arg1 : tensor<17xf32>, tensor<17xf32>) outs(%arg2 : tensor<17xf32>) -> tensor<17xf32>
      NAIL.yield %z : tensor<17xf32>
    }
    return %r : tensor<17xf32>
  }
}
