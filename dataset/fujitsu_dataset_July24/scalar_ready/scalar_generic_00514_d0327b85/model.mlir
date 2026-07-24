module {
  func.func @kernel(%arg0: tensor<909xi16>, %arg1: tensor<909xi16>) -> tensor<909xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 0> -> tensor<909xi16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<909xi16>) outs(%arg1 : tensor<909xi16>) {
    ^bb0(%in: i16, %out: i16):
      %0 = arith.muli %in, %out : i16
      %1 = arith.addi %in, %0 : i16
      %2 = arith.muli %in, %1 : i16
      %3 = arith.addi %in, %2 : i16
      %4 = arith.maxsi %in, %3 : i16
      linalg.yield %4 : i16
    } -> tensor<909xi16>
      NAIL.yield %g : tensor<909xi16>
    }
    return %r : tensor<909xi16>
  }
}
