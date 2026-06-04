// Decompose `linalg.softmax` into reduction + elementwise generics using the
// transform dialect. softmax is an aggregate op (AggregatedOpInterface); the
// `decompose_interface` transform expands it into:
//   max-reduction -> exp(x - max) -> sum-reduction -> divide  (+ init fills)
// Each of those pieces individually lowers on VE/Scalar.
//
// Run with the upstream mlir-opt (it knows the transform dialect):
//   mlir-opt softmax_decompose.mlir --transform-interpreter
//
// Note: this needs *upstream* mlir-opt, not ofa-opt. The transform sequence is
// consumed by --transform-interpreter and removed from the output.

module attributes {transform.with_named_sequence} {
  func.func @main(%a: tensor<8x16xf32>, %o: tensor<8x16xf32>) -> tensor<8x16xf32> {
    %0 = linalg.softmax dimension(1)
           ins(%a : tensor<8x16xf32>) outs(%o : tensor<8x16xf32>) -> tensor<8x16xf32>
    return %0 : tensor<8x16xf32>
  }

  transform.named_sequence @__transform_main(
      %arg0: !transform.any_op {transform.readonly}) {
    %sm = transform.structured.match ops{["linalg.softmax"]} in %arg0
        : (!transform.any_op) -> !transform.any_op
    %decomposed = transform.structured.decompose_interface %sm
        : (!transform.any_op) -> !transform.any_op
    transform.yield
  }
}
