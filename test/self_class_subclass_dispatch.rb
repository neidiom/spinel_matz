# Issue #422. `self.class.<cmeth>` inside a parent-defined
# instance method must dispatch to the subclass override at
# runtime, not to the parent's cmeth. Pre-fix the codegen
# resolved cmeth statically against the method body's defining
# class, so a Child instance routed through a Base-defined
# `describe` always landed on `Base.label`.
#
# Fix shape:
#   - lib structs: every non-value-type sp_<C> gets `mrb_int
#     cls_id` as its first field (layout-roots emit it; subclasses
#     inherit via parent-fields-first ordering, so a cast preserves
#     the offset).
#   - constructors: `sp_<C>_new` writes `self->cls_id = <C's idx>`
#     so the runtime carries the concrete class tag.
#   - chained dispatch: `<recv>.class.<cmeth>()` lowers to a
#     `switch (<recv>->cls_id)` when descendants of recv's static
#     class override the cmeth.
#
# Coverage:
#   - Plain Base/Child override.
#   - Multi-level (GrandChild overrides label).
#   - Subclass that doesn't override -- inherits via the default
#     (Sibling has no .label, falls through to Base).
#   - Direct Base instance still routes to Base.

class Base
  def self.label
    "BASE"
  end

  def describe
    self.class.label
  end
end

class Child < Base
  def self.label
    "CHILD"
  end
end

class GrandChild < Child
  def self.label
    "GRANDCHILD"
  end
end

class Sibling < Base
end

puts Base.new.describe
puts Child.new.describe
puts GrandChild.new.describe
puts Sibling.new.describe
