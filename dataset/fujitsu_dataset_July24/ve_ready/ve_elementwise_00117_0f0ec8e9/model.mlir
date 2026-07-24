module {
  func.func @kernel(%arg0: tensor<123x39xf32>, %arg1: tensor<123x39xf32>, %arg2: tensor<123x39xf32>) -> tensor<123x39xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<123x39xf32> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<mul> ins(%arg0, %arg1 : tensor<123x39xf32>, tensor<123x39xf32>) outs(%arg2 : tensor<123x39xf32>) -> tensor<123x39xf32>
      NAIL.yield %z : tensor<123x39xf32>
    }
    return %r : tensor<123x39xf32>
  }
}
