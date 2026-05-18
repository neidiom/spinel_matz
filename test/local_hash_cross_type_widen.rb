# Cross-type `[]=` write on a non-empty hash literal should widen the
# LV's hash type so the store accepts the new value via boxing.
# Before this fix, `m = {"a" => "1"}; m["k"] = 42` lowered to
# `sp_StrStrHash_set(m, "k", 42LL)` -- gcc rejected the mrb_int passed
# where a `const char *` was expected.
#
# Fix: scan_locals's CallNode `[]=` arm widens the LV from a narrow
# variant (str_str_hash / sym_int_hash / etc.) to its corresponding
# `*_poly_hash` when the new write's key or value type doesn't fit
# the current variant. The LV-write emit then builds the literal
# init as the widened poly variant directly (boxing each value).
# Issue #589.

# str_str_hash → str_poly_hash via int value
m = {"a" => "1"}
m["k"] = 42
puts m.length          # 2
puts m["a"]            # "1"
puts m["k"]            # 42

# str_int_hash → str_poly_hash via string value
n = {"x" => 10, "y" => 20}
n["z"] = "thirty"
puts n.length          # 3
puts n["x"]            # 10
puts n["z"]            # "thirty"

# sym_int_hash → sym_poly_hash via string value
o = {a: 1, b: 2}
o[:c] = "three"
puts o.length          # 3
puts o[:a]             # 1
puts o[:c]             # "three"

# sym_str_hash unchanged when same value-type written
p = {x: "one", y: "two"}
p[:z] = "three"
puts p.length          # 3
puts p[:y]             # two

# str_str_hash unchanged when same value-type written -- the widening
# arm only fires on a real key/value mismatch, so consistent writes
# stay on the narrow variant.
q = {"a" => "1"}
q["b"] = "2"
puts q.length          # 2
puts q["b"]            # "2"
