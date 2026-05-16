# #554 (cielavenir). `(a, b = 10, 11)` used as an expression
# returns the RHS array in CRuby semantics; pre-fix spinel
# fell through to the int 0 default, and the wrapping `[1]`
# subscript lowered to bit extraction on 0 instead of indexing
# the RHS array. Both analyze (infer_type) and codegen
# (compile_expr) needed MultiWriteNode arms.
#
# Current scope: only the ArrayNode-rhs shape with
# homogeneous all-int or all-string elements lowers to a
# matching typed-array temp; mixed shapes lower to PolyArray.
# Splat / nested-destructure shapes still fall through.

p( (a, b = 10, 11)[1] )

# Verify the side-effect assignments still happened.
p a
p b

# String case routes through StrArray.
arr = (x, y = "hi", "lo")
p arr[0]
p arr[1]
p x
p y
