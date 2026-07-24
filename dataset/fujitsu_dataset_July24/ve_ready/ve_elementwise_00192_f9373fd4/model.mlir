module {
  func.func @kernel(%arg0: tensor<132x28xi8>, %arg1: tensor<132x28xi8>, %arg2: tensor<132x28xi8>) -> tensor<132x28xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<132x28xi8> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<max_signed> ins(%arg0, %arg1 : tensor<132x28xi8>, tensor<132x28xi8>) outs(%arg2 : tensor<132x28xi8>) -> tensor<132x28xi8>
      NAIL.yield %z : tensor<132x28xi8>
    }
    return %r : tensor<132x28xi8>
  }
}
