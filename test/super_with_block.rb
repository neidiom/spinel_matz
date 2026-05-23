# Issue #665: `super { ... }` from a child method passes a literal block
# to the parent. Pre-fix the parser dropped ForwardingSuperNode's block
# field and compile_super_expr emitted `sp_Parent_test((sp_Parent*)self)`
# which type-checked one arg against a 3-arg signature
# `(self, _block, _benv)` and failed at C compile. The fix wires the
# block through the parser, then inlines the parent body in place of
# the call (mirroring compile_yield_call_expr) so `yield` inside the
# parent body becomes the literal block body.
class Parent
  def test
    yield
  end
end

class Child < Parent
  def test
    super { puts "from child" }
  end
end

Child.new.test
