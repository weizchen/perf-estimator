module {
  func.func @kernel(%arg0: tensor<67x327xf32>, %arg1: tensor<67x327xf32>) -> tensor<67x327xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<67x327xf32> {
    %z = linalg.copy ins(%arg0 : tensor<67x327xf32>) outs(%arg1 : tensor<67x327xf32>) -> tensor<67x327xf32>
      NAIL.yield %z : tensor<67x327xf32>
    }
    return %r : tensor<67x327xf32>
  }
}
