module {
  func.func @kernel(%arg0: tensor<253xi8>, %arg1: tensor<253xi8>, %arg2: tensor<253xi8>) -> tensor<253xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<253xi8> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<add> ins(%arg0, %arg1 : tensor<253xi8>, tensor<253xi8>) outs(%arg2 : tensor<253xi8>) -> tensor<253xi8>
      NAIL.yield %z : tensor<253xi8>
    }
    return %r : tensor<253xi8>
  }
}
