module {
  func.func @kernel(%arg0: tensor<118x190xf32>, %arg1: tensor<190xf32>) -> tensor<190xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<190xf32> {
    %z = linalg.reduce ins(%arg0 : tensor<118x190xf32>) outs(%arg1 : tensor<190xf32>) dimensions = [0]
      (%in: f32, %acc: f32) {
        %s = arith.mulf %in, %acc : f32
        linalg.yield %s : f32
      }
      NAIL.yield %z : tensor<190xf32>
    }
    return %r : tensor<190xf32>
  }
}
