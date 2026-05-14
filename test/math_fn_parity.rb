# Math.<fn> name set is hard-coded in two places that need to
# stay in sync:
#   spinel_analyze.rb:math_fn_returns_float? — the analyze-side
#     gate that types Math.<fn> calls as float
#   spinel_codegen.rb:math_fn_one_arg? / math_fn_two_arg? — the
#     codegen-side dispatch that emits the libm call
# This file exercises every recognized Math fn end-to-end so a
# drift (e.g. adding `cbrt` to one side but not the other) fails
# the build instead of silently dropping the function. The
# output is exact ints (`.to_i.to_s`) to keep platform float
# noise out of the diff.

puts Math.sqrt(16.0).to_i.to_s
puts Math.cos(0.0).to_i.to_s
puts Math.sin(0.0).to_i.to_s
puts Math.tan(0.0).to_i.to_s
puts Math.acos(1.0).to_i.to_s
puts Math.asin(0.0).to_i.to_s
puts Math.atan(0.0).to_i.to_s
puts Math.sinh(0.0).to_i.to_s
puts Math.cosh(0.0).to_i.to_s
puts Math.tanh(0.0).to_i.to_s
puts Math.asinh(0.0).to_i.to_s
puts Math.acosh(1.0).to_i.to_s
puts Math.atanh(0.0).to_i.to_s
puts Math.log(1.0).to_i.to_s
puts Math.log2(1.0).to_i.to_s
puts Math.log10(1.0).to_i.to_s
puts Math.exp(0.0).to_i.to_s
puts Math.atan2(0.0, 1.0).to_i.to_s
puts Math.hypot(3.0, 4.0).to_i.to_s
