module {
  func.func @kernel(%arg0: tensor<15x156xi8>, %arg1: tensor<15x156xi8>, %arg2: tensor<15x156xi8>) -> tensor<15x156xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<15x156xi8> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<mul> ins(%arg0, %arg1 : tensor<15x156xi8>, tensor<15x156xi8>) outs(%arg2 : tensor<15x156xi8>) -> tensor<15x156xi8>
      NAIL.yield %z : tensor<15x156xi8>
    }
    return %r : tensor<15x156xi8>
  }
}
