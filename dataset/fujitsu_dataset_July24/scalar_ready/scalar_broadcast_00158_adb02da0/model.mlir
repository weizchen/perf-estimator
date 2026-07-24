module {
  func.func @kernel(%arg0: tensor<47xf32>, %arg1: tensor<455x47xf32>) -> tensor<455x47xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<455x47xf32> {
    %z = linalg.broadcast ins(%arg0 : tensor<47xf32>) outs(%arg1 : tensor<455x47xf32>) dimensions = [0]
      NAIL.yield %z : tensor<455x47xf32>
    }
    return %r : tensor<455x47xf32>
  }
}
