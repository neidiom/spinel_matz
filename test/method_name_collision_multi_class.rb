# Issue #407 case 2/3. Multiple unrelated classes define the
# same method name; cross-class poly-recv widening picks the
# correct param types via arity match.
#
# Pre-fix the scan_new_calls' forward-ref widening at line
# 9910 bailed when more than one user class defined the same
# `mname` (matched_ci_fwd = -2 = ambiguous), leaving every
# candidate's params at the int default. Heterogeneous-array
# iteration (`[IndexHandler.new, UsersHandler.new].each |h|;
# h.handle(req, res); end`) then C-compiled with
# `IndexHandler#handle(int, int)` against a `"/"` arg ->
# Wint-conversion error.
#
# Fix: when the recv is statically `int`/unresolved
# (var-type-table-not-yet-populated case matz called out),
# walk every user class with the method and widen the ones
# whose ptypes count matches the call's arg count. The arity
# filter excludes attr_accessor entries (0-param getters)
# that happen to share the name with a multi-arg def.
#
# Coverage:
#   - Two unrelated classes (Index/UsersHandler) define
#     `handle(req, res)` -- both get widened to (string, string)
#     from the heterogeneous-array iteration's "/" + "" call site.
#   - A third class (SQLite) has `attr_accessor :handle` (a
#     0-param getter). Its ptypes count (0) doesn't match the
#     call's arg count (2), so the arity filter excludes it
#     from the widening.
#   - The SQLite attr_accessor path is still reachable via
#     `db.handle` (0-arg call) and returns the ivar value
#     unchanged.

class IndexHandler
  def handle(req, res); "i-" + req + ":" + res; end
end
class UsersHandler
  def handle(req, res); "u-" + req + ":" + res; end
end
class SQLite
  attr_accessor :handle
  def initialize(name); @handle = name; end
end

handlers = [IndexHandler.new, UsersHandler.new]
i = 0
while i < handlers.length
  h = handlers[i]
  puts h.handle("/", "ok")
  i += 1
end

db = SQLite.new("conn-1")
puts db.handle
