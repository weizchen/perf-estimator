module {
  func.func @kernel(%arg0: tensor<278x21xi1>, %arg1: tensor<278x21xf32>, %arg2: tensor<278x21xf32>, %arg3: tensor<278x21xf32>) -> tensor<278x21xf32> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<278x21xf32> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<278x21xi1>, tensor<278x21xf32>, tensor<278x21xf32>) outs(%arg3 : tensor<278x21xf32>) -> tensor<278x21xf32>
      NAIL.yield %z : tensor<278x21xf32>
    }
    return %r : tensor<278x21xf32>
  }
}
