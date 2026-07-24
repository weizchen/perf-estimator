module {
  func.func @kernel(%arg0: tensor<77xi8>, %arg1: tensor<77xi8>, %arg2: tensor<77xi8>) -> tensor<77xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<77xi8> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<sub> ins(%arg0, %arg1 : tensor<77xi8>, tensor<77xi8>) outs(%arg2 : tensor<77xi8>) -> tensor<77xi8>
      NAIL.yield %z : tensor<77xi8>
    }
    return %r : tensor<77xi8>
  }
}
