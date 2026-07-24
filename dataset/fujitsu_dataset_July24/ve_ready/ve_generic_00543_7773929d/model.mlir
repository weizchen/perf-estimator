module {
  func.func @kernel(%arg0: tensor<37xi8>, %arg1: tensor<37xi8>) -> tensor<37xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<37xi8> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<37xi8>) outs(%arg1 : tensor<37xi8>) {
    ^bb0(%in: i8, %out: i8):
      %0 = arith.addi %in, %out : i8
      linalg.yield %0 : i8
    } -> tensor<37xi8>
      NAIL.yield %g : tensor<37xi8>
    }
    return %r : tensor<37xi8>
  }
}
