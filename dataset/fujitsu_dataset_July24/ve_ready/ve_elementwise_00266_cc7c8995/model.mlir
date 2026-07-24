module {
  func.func @kernel(%arg0: tensor<109xf32>, %arg1: tensor<109xf32>) -> tensor<109xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<109xf32> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<exp> ins(%arg0 : tensor<109xf32>) outs(%arg1 : tensor<109xf32>) -> tensor<109xf32>
      NAIL.yield %z : tensor<109xf32>
    }
    return %r : tensor<109xf32>
  }
}
