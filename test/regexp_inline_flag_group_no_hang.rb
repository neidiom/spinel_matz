# `(?xim:...)` inline-flag groups previously parsed into an infinite
# loop in re_compile: the `?` after `(` didn't match any recognized
# directive (`:`, `=`, `!`, `<...`) and didn't advance c->p, so
# compile_seq's outer loop spun forever on the unconsumed `?`.
# Sam Ruby's #600 puzzle 3 (`p(/(?x:foo)/.to_s)`) hung at runtime
# during the sp_re_init's static-regex compilation.
#
# Fix: when the `(?` lookahead matches a recognized flag char
# (x / i / m / s / u / a), consume to `:` (non-capturing body)
# or `)` (whole-group flag application -- spinel doesn't track
# scoped flag state, so the directive is consumed without
# emitting). Unrecognized `(?<X>` now raises a clean
# `unrecognized (? construct` compile_error instead of hanging.
#
# Semantically /x's whitespace-stripping IS NOT applied inside
# the sub-pattern -- spinel's compile-time flag handling only
# does top-level stripping. Patterns whose `/x` flag is decorative
# (whitespace inside `(?x:body)` for layout only) match the same
# as the spinel literal would; patterns relying on the strip
# would behave differently, but no longer hang.

# `(?x:...)` with no whitespace in body. /foo/ matches "foo".
puts (/(?x:foo)/ =~ "foobar").to_s     # 0
puts (/(?x:foo)/ =~ "barbaz").nil?     # true

# `(?:...)` non-capturing still works.
puts (/(?:hello) (?:world)/ =~ "hello world").to_s  # 0

# `(?i:...)` consumes the flag; spinel doesn't honor case-insensitivity
# inside the group, but the parse no longer hangs.
puts (/(?i:abc)/ =~ "abc").to_s       # 0

# `(?m:...)` similar.
puts (/(?m:foo)/ =~ "foo").to_s       # 0
