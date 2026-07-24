module {
  func.func @kernel(%arg0: tensor<2342xi8>, %arg1: tensor<2342xi8>) -> tensor<2342xi8> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<2342xi8> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<2342xi8>) outs(%arg1 : tensor<2342xi8>) {
    ^bb0(%in: i8, %out: i8):
      %0 = arith.muli %in, %out : i8
      %1 = arith.addi %in, %0 : i8
      %2 = arith.muli %in, %1 : i8
      %3 = arith.addi %in, %2 : i8
      %4 = arith.maxsi %in, %3 : i8
      linalg.yield %4 : i8
    } -> tensor<2342xi8>
      NAIL.yield %g : tensor<2342xi8>
    }
    return %r : tensor<2342xi8>
  }
}
