# `<user_obj>.class` collapses to the class name as a string.
# Spinel doesn't allocate runtime Class objects, so the only
# coherent representation for `obj.class` is the textual name.
# The two real-world consumers in optcarrot are:
#   1. `"#<#{ self.class }>"`-style interpolation in `inspect`
#   2. `self.class.to_s.split("::").last`-style introspection
# Both work fine if `.class` simply yields the class name as a
# string (the second loses the `::` namespace because Spinel
# flattens nested modules with `_`, but that's a cosmetic loss).

class Foo
  def to_s
    "<" + self.class + ">"
  end
end

class Bar
  def label
    self.class.to_s
  end
end

puts Foo.new.to_s   # => <Foo>
puts Bar.new.label  # => Bar
