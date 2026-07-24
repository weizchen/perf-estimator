module {
  func.func @kernel(%arg0: tensor<74xf32>, %arg1: tensor<74xf32>, %arg2: tensor<74xf32>) -> tensor<74xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<74xf32> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<div> ins(%arg0, %arg1 : tensor<74xf32>, tensor<74xf32>) outs(%arg2 : tensor<74xf32>) -> tensor<74xf32>
      NAIL.yield %z : tensor<74xf32>
    }
    return %r : tensor<74xf32>
  }
}
