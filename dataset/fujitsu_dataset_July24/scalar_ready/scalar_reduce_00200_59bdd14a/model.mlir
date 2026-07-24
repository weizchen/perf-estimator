module {
  func.func @kernel(%arg0: tensor<383x13x288xf32>, %arg1: tensor<383x288xf32>) -> tensor<383x288xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<383x288xf32> {
    %z = linalg.reduce ins(%arg0 : tensor<383x13x288xf32>) outs(%arg1 : tensor<383x288xf32>) dimensions = [1]
      (%in: f32, %acc: f32) {
        %s = arith.mulf %in, %acc : f32
        linalg.yield %s : f32
      }
      NAIL.yield %z : tensor<383x288xf32>
    }
    return %r : tensor<383x288xf32>
  }
}
