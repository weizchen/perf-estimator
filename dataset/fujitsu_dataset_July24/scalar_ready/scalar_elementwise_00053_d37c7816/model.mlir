module {
  func.func @kernel(%arg0: tensor<20x112xf32>, %arg1: tensor<20x112xf32>, %arg2: tensor<20x112xf32>) -> tensor<20x112xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<20x112xf32> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<add> ins(%arg0, %arg1 : tensor<20x112xf32>, tensor<20x112xf32>) outs(%arg2 : tensor<20x112xf32>) -> tensor<20x112xf32>
      NAIL.yield %z : tensor<20x112xf32>
    }
    return %r : tensor<20x112xf32>
  }
}
