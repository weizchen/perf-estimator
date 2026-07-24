module {
  func.func @kernel(%arg0: tensor<9x10xf32>, %arg1: tensor<10xf32>) -> tensor<10xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<10xf32> {
    %z = linalg.reduce ins(%arg0 : tensor<9x10xf32>) outs(%arg1 : tensor<10xf32>) dimensions = [0]
      (%in: f32, %acc: f32) {
        %s = arith.mulf %in, %acc : f32
        linalg.yield %s : f32
      }
      NAIL.yield %z : tensor<10xf32>
    }
    return %r : tensor<10xf32>
  }
}
