module {
  func.func @kernel(%arg0: tensor<36xf32>, %arg1: tensor<36xf32>, %arg2: tensor<36xf32>) -> tensor<36xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<36xf32> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<div> ins(%arg0, %arg1 : tensor<36xf32>, tensor<36xf32>) outs(%arg2 : tensor<36xf32>) -> tensor<36xf32>
      NAIL.yield %z : tensor<36xf32>
    }
    return %r : tensor<36xf32>
  }
}
