module {
  func.func @kernel(%arg0: tensor<361x241x392xf32>, %arg1: tensor<361x392xf32>) -> tensor<361x392xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<361x392xf32> {
    %z = linalg.reduce ins(%arg0 : tensor<361x241x392xf32>) outs(%arg1 : tensor<361x392xf32>) dimensions = [1]
      (%in: f32, %acc: f32) {
        %s = arith.addf %in, %acc : f32
        linalg.yield %s : f32
      }
      NAIL.yield %z : tensor<361x392xf32>
    }
    return %r : tensor<361x392xf32>
  }
}
