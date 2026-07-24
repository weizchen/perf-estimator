module {
  func.func @kernel(%arg0: tensor<7366xi16>, %arg1: tensor<7366xi16>) -> tensor<7366xi16> {
    %r = NAIL.unit {schedule = 0 : i64} : !NAIL.target<i : 0, j : 0, proc : 1> -> tensor<7366xi16> {
      %g = linalg.generic {indexing_maps = [affine_map<(d0) -> (d0)>, affine_map<(d0) -> (d0)>], iterator_types = ["parallel"]} ins(%arg0 : tensor<7366xi16>) outs(%arg1 : tensor<7366xi16>) {
    ^bb0(%in: i16, %out: i16):
      %0 = arith.addi %in, %out : i16
      linalg.yield %0 : i16
    } -> tensor<7366xi16>
      NAIL.yield %g : tensor<7366xi16>
    }
    return %r : tensor<7366xi16>
  }
}
