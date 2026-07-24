module {
  func.func @kernel(%arg0: tensor<20x390xi8>, %arg1: tensor<20x390xi8>, %arg2: tensor<20x390xi8>) -> tensor<20x390xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<20x390xi8> {
    %z = linalg.elementwise kind=#linalg.elementwise_kind<add> ins(%arg0, %arg1 : tensor<20x390xi8>, tensor<20x390xi8>) outs(%arg2 : tensor<20x390xi8>) -> tensor<20x390xi8>
      NAIL.yield %z : tensor<20x390xi8>
    }
    return %r : tensor<20x390xi8>
  }
}
