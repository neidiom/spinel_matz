# FloatArray#pop / FloatArray#shift / StrArray#pop must raise
# FrozenError on a frozen array, matching IntArray#pop/#shift.

f = [1.5, 2.5, 3.5]
f.freeze
begin
  f.pop
  puts "BUG pop: no raise"
rescue FrozenError => e
  puts "pop: " + e.message
end

f2 = [1.5, 2.5, 3.5]
f2.freeze
begin
  f2.shift
  puts "BUG shift: no raise"
rescue FrozenError => e
  puts "shift: " + e.message
end

s = ["a", "b", "c"]
s.freeze
begin
  s.pop
  puts "BUG str_pop: no raise"
rescue FrozenError => e
  puts "str_pop: " + e.message
end
