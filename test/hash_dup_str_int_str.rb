# Hash#dup was missing from the str_str_hash and int_str_hash codegen
# dispatch tables -- the runtime helpers exist (sp_StrStrHash_dup,
# sp_IntStrHash_dup) but the codegen arms didn't dispatch to them, so
# `m = h.dup` lowered to `cannot resolve call to 'dup' on str_str_hash
# (emitting 0)` and subsequent `.length` / `[]=` / `.each` calls on
# the int-typed `0` segfaulted at runtime.
#
# Sibling Hash variants (sym_int / sym_str / sym_poly / str_int /
# str_poly) already had dup arms; this closes the coverage gap.
# Issue #592.

# str_str_hash
h1 = {"a" => "1", "b" => "2"}
m1 = h1.dup
m1["c"] = "3"
puts h1.length          # 2
puts m1.length          # 3
puts m1["a"]            # 1
puts m1["c"]            # 3

# int_str_hash
h2 = {1 => "one", 2 => "two"}
m2 = h2.dup
m2[3] = "three"
puts h2.length          # 2
puts m2.length          # 3
puts m2[1]              # one
puts m2[3]              # three

# Verify the dup is independent (original unchanged).
puts h1.has_key?("c")   # false
puts h2.has_key?(3)     # false
