module {
  func.func @kernel(%arg0: tensor<70x303xf32>, %arg1: tensor<70x303xf32>, %arg2: tensor<70x303xf32>) -> tensor<70x303xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<70x303xf32> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<min_signed> ins(%arg0, %arg1 : tensor<70x303xf32>, tensor<70x303xf32>) outs(%arg2 : tensor<70x303xf32>) -> tensor<70x303xf32>
      NAIL.yield %z : tensor<70x303xf32>
    }
    return %r : tensor<70x303xf32>
  }
}
