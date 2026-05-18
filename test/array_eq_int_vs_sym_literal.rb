# `[0,0,0] == %i[a a a]` must answer FALSE -- CRuby compares element
# classes too, so int 0 != sym :a even when their encoded ids match.
# Spinel's sym_array storage shares the sp_IntArray layout with
# int_array (sym ids stored as raw mrb_int), and sp_IntArray_eq
# compares raw bytes. With SPS_a == 0, both arrays' bytes are
# [0,0,0] and the eq returned `true`, breaking `!=` to false.
#
# Fix: when the equality is between literal `[...]` and literal
# `%i[...]` and the static types differ (int_array vs sym_array),
# short-circuit to FALSE. The `<<`-widened "int_array carrying
# syms at runtime" shape from issue #555 keeps both sides typed
# `int_array` (the analyzer leaves the static type alone), so the
# guard's "different static types" condition doesn't fire and
# IntArray_eq continues to apply. Issue #600 puzzle 1.

p [0, 0, 0] != %i[a a a]                 # true
p [0, 0, 0] == %i[a a a]                 # false
p %i[a a a] != [0, 0, 0]                 # true

# Sibling shapes -- arrays of the same element-kind still compare
# correctly via IntArray_eq.
p [1, 2, 3] == [1, 2, 3]                 # true
p %i[a b c] == %i[a b c]                 # true
p %i[a b c] != %i[a b]                   # true (length differs)

# Issue #555 test #6 shape: int_array with sym pushes at runtime.
# Both sides resolve to lt == at == "int_array" statically, so the
# new guard doesn't engage and IntArray_eq compares element ids
# (which match for the :foo pushed and the :foo literal in [:foo]).
a = [1]
a.shift
a << :foo
p a == [:foo]                            # true
