module {
  func.func @kernel(%arg0: tensor<361x9xi1>, %arg1: tensor<361x9xi16>, %arg2: tensor<361x9xi16>, %arg3: tensor<361x9xi16>) -> tensor<361x9xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<361x9xi16> {
    %z = linalg.select ins(%arg0, %arg1, %arg2 : tensor<361x9xi1>, tensor<361x9xi16>, tensor<361x9xi16>) outs(%arg3 : tensor<361x9xi16>) -> tensor<361x9xi16>
      NAIL.yield %z : tensor<361x9xi16>
    }
    return %r : tensor<361x9xi16>
  }
}
