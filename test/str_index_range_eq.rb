# `s[i..i] == "/"` used to skip compile_string_method_expr's `[]`
# RangeNode arm and hit the `s[i] == "/"` single-char fast path
# instead (compile_eq_char_index), which cast the RangeNode to
# mrb_int and emitted `lv_s[(mrb_int)sp_range_new(i, i)] == '/'` —
# C compile failure ("aggregate value used where an integer was
# expected"). Issue #644.
#
# Fix: the single-char fast path bails out when the `[]` arg is a
# Range or a 2-arg `s[start, len]` form, so the call falls through
# to the proper sp_str_sub_range dispatch + string compare.

s = "abc/def"
i = 3
if s[i..i] == "/"
  puts "match"
end

# Range literal as the [] arg (no LV indirection).
puts s[1..2]            # "bc"
puts s[3..3] == "/"     # true

# Exclusive range.
puts s[3...4] == "/"    # true

# `s[start, len]` 2-arg form must also fall through cleanly.
puts s[3, 1] == "/"     # true
