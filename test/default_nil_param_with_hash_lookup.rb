# #482. `def m(other = nil)` whose body uses `other[key]` (Hash
# receiver index read) failed C compile when the lookup result
# landed in a concretely-typed pointer field. With no caller
# passing a non-nil `other`, spinel typed the param at the
# `mrb_int` default; `other["key"]` fell through to the
# unresolved-call warning (emits 0); and the resulting `lv_v`
# assigned to the typed `iv_s` slot tripped
# -Wint-conversion. Both the `return if other.nil?` and the
# `if !v.nil?` guards folded away because spinel reasoned about
# `mrb_int 0` as Integer 0 whose `.nil?` is false.
#
# Fix: a new back-propagation pass detects an int-typed param
# with `nil` default whose body uses it as a String-keyed Hash
# receiver, and widens the param's stored type from int to
# str_str_hash. Spinel already treats hash pointers as nullable,
# so the early-return / `.nil?` checks survive DCE.

class Box
  attr_accessor :s

  def initialize(other = nil)
    @s = nil
    return if other.nil?
    v = other["key"]
    @s = v if !v.nil?
  end
end

b = Box.new
b.s = "hello"
puts b.s
