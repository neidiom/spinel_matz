# Method aliases / shapes from #619 puzzles 8 / 9 / 10:
#   Array#at(n)      -> Array#[n]
#   Array#append(x)  -> Array#push(x), returning self (the array)
#   String#chomp!    -> String#chomp (matches the changed-case;
#                       the Ruby `nil if no change` mutator semantic
#                       isn't preserved since spinel strings are
#                       immutable)
# Pre-fix all three lowered to the unresolved-call fallback "emit 0"
# and the comparison surfaces returned false.

p([1, 2, 3].at(1) == 2)
p(%w[a].append("b") == %w[a b])
p("ab\n".chomp! == "ab")
